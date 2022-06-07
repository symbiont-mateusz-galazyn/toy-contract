from assembly_client.api.network_client import NetworkClient

client = NetworkClient(None,'.',10).refresh_config(network_config_path='/home/work/.symbiont/assembly-dev/dev-network/default/network-config.json')

key_alias = client.register_key_alias()
client.publish(contract_dir='chat/contract/directory/')

print(f'contracts: {client.contracts}')
print(f'key aliases: {client.key_aliases}')
