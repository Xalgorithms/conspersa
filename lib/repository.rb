module Tatev
  class Repository
    def initialize(root)
      @root = root
      if Dir.exists?(@root)
        @git_repo = Rugged::Repository.new(@root)
      else
        @git_repo = Rugged::Repository.init_at(@root)
      end
    end

    def add(invocation_id, context_id, content)
      store_file(invocation_id, context_id, content, "Original: #{invocation_id}/#{context_id}")
    end

    def update(invocation_id, context_id, content)
      store_file(invocation_id, context_id, content, "Updated: #{invocation_id}/#{context_id}")
    end

    def get(invocation_id, context_id, &bl)
      fn = make_path(invocation_id, context_id)
      bl.call(MultiJson.decode(File.read(fn))) if bl
    end
    
    private

    def store_file(invocation_id, context_id, content, message)
      fn = store_content(invocation_id, context_id, content)
      commit_file(fn, message)
    end

    def make_path(invocation_id, context_id)
      invocation_path = File.join(@root, invocation_id)
      if !Dir.exists?(invocation_path)
        Dir.mkdir(invocation_path)
      end

      File.join(invocation_path, "#{context_id}.json")
    end
    
    def store_content(invocation_id, context_id, content)
      fn = make_path(invocation_id, context_id)
      File.open(fn, 'w') do |f|
        f.write(content)
      end

      File.join(invocation_id, "#{context_id}.json")
    end

    def commit_file(fn, m)
      oid = @git_repo.write(m, :blob)
      index = @git_repo.index
      index.add(path: fn, oid: oid, mode: 0100644)
      index.write

      who = {
        email: "registry@xalgorithms.org",
        name: "Registry",
        time: Time.now,
      }
      
      opts = {
        tree: index.write_tree(@git_repo),
        author: who, committer: who,
        message: m,
        parents: (@git_repo.empty? ? [] : [@git_repo.head.target].compact),
        update_ref: 'HEAD',
      }

      Rugged::Commit.create(@git_repo, opts)

      oid
    end
  end
end
