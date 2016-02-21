require Padrino.root('app/app.rb')

Padrino.mount('Tatev::App', app_file: Padrino.root('app/app.rb')).to('/')
