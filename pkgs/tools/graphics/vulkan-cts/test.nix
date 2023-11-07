{ lib, makeImpureTest, vulkan-cts, mesa }:
makeImpureTest {
  name = "vulkan-cts";
  testedPackage = "vulkan-cts";

  sandboxPaths = [ "/sys" "/dev/dri" ];

  nativeBuildInputs = [ vulkan-cts ];

  # Make mesa drivers available, they should support most common GPUs
  testScript = ''
    icds=(${mesa.drivers}/share/vulkan/icd.d/*.json)
    IFS=: eval 'export VK_ICD_FILENAMES=''${icds[*]}'
    echo VK_ICD_FILENAMES="$VK_ICD_FILENAMES"

    deqp-vk -n dEQP-VK.api.smoke.triangle
  '';

  meta = with lib.maintainers; {
    maintainers = [ Flakebi ];
  };
}
