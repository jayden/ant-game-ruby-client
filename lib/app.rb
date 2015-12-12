require_relative './nest'
require_relative './client'

client = Client.new("localhost", "8888")
nest = Nest.new("Ant-Team", client)

nest.run
