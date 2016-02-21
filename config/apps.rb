require Padrino.root('api/app.rb')

Padrino.mount('Tatev::API::App', app_file: Padrino.root('api/app.rb')).to('/')
