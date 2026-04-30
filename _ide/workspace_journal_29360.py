# 2026-04-30T13:59:34.409984900
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

comp = client.get_component(name="hello_world")
comp.set_app_config(key = "USER_INCLUDE_DIRECTORIES", values = ["CMSIS_DSP"])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

vitis.dispose()

