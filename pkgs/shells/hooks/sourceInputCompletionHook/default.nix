{ makeSetupHook, findutils, substituteAll }:

# See the header comment in ./source-input-completion-hook.sh for example usage.
makeSetupHook { name = "source-input-completion-hook"; } (
  substituteAll {
    src = ./source-input-completion-hook.sh;
    inherit findutils;
  })
