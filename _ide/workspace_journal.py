# 2026-06-07T15:27:11.040690
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

platform = client.get_component(name="platform")
status = platform.build()

comp = client.get_component(name="hello_world")
comp.build()

status = platform.build()

comp.build()

status = platform.build()

comp.build()

client.delete_component(name="platform")

client.delete_component(name="componentName")

client.delete_component(name="hello_world")

client.delete_component(name="hello_world")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../Test_Top.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

status = platform.build()

comp.build()

client.delete_component(name="hello_world")

client.delete_component(name="platform")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../Test_Top.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

status = platform.build()

comp = client.create_app_component(name="hello_world",platform = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm",domain = "standalone_ps7_cortexa9_0",template = "hello_world")

status = platform.build()

comp.build()

