# 2026-04-25T14:08:23.900792800
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

client.delete_component(name="platform")

client.delete_component(name="hello_world")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../Test_Top.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

client.delete_component(name="hello_world")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

comp = client.get_component(name="hello_world")
comp.set_app_config(key = "USER_INCLUDE_DIRECTORIES", values = [""])

comp.set_app_config(key = "USER_INCLUDE_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/CMSIS_DSP"])

comp.set_app_config(key = "USER_LINK_LIBRARIES", values = [""])

comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["CMSISDSP"])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src"])

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

comp = client.get_component(name="hello_world")
comp.set_app_config(key = "USER_INCLUDE_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src/CMSIS_DSP"])

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

client.delete_component(name="hello_world")

client.delete_component(name="platform")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../Test_Top.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

comp = client.get_component(name="hello_world")
comp.set_app_config(key = "USER_INCLUDE_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src/CMSIS_DSP"])

comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["CMSISDSP"])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src"])

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

client.delete_component(name="hello_world")

client.delete_component(name="platform")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../Test_Top.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

comp = client.get_component(name="hello_world")
comp.set_app_config(key = "USER_INCLUDE_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src/CMSIS_DSP"])

comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["CMSISDSO"])

comp.set_app_config(key = "USER_LINK_LIBRARIES", values = [""])

comp.set_app_config(key = "USER_LINK_LIBRARIES", values = ["CMSISDSP"])

comp.set_app_config(key = "USER_LINK_DIRECTORIES", values = ["C:/Users/Tetro/Documents/FPGA_Project/2025_G/hello_world/src"])

status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

vitis.dispose()

