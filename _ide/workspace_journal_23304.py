# 2026-04-20T22:08:32.394534600
import vitis

client = vitis.create_client()
client.set_workspace(path="2025_G")

platform = client.create_platform_component(name = "platform",hw_design = "$COMPONENT_LOCATION/../Test_Top.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",compiler = "gcc")

