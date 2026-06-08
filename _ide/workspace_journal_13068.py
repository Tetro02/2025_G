# 2026-05-19T15:08:57.330874100
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

