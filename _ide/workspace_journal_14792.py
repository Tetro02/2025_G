# 2026-06-08T16:18:25.450787200
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

client.delete_component(name="hello_world")

client.delete_component(name="hello_world")

