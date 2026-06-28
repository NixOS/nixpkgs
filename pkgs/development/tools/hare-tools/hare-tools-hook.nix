{
  hareHook,
  makeSetupHook,
  lib
}:

makeSetupHook {
  name = "hare-tools-hook";
  propagatedBuildInputs = [ hareHook ];
  maintainers = with lib.maintainers; [ snifexx ];
  meta = {
    description = "Setup hook for the Hare tools";
    inherit (hareHook.meta) badPlatforms platforms;
  };
} ./hare-tools-hook.sh
