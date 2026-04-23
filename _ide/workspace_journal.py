# 2026-04-23T16:45:15.566527600
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

comp = client.get_component(name="hello_world")
comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["CMSISDSP"])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = [".", "C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src"])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["."])

vitis.dispose()

