# Warning: Need to update at the same time as pytorch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "0.9.1" = {
    x86_64-linux-37 = {
      name = "torchaudio-0.9.1-cp37-cp37m-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.9.1-cp37-cp37m-linux_x86_64.whl";
      hash = "sha256-Vr7rQJlt0OMyKsnAbgiu26puE+3pW1UG8e8la/sBC3g=";
    };
    x86_64-linux-38 = {
      name = "torchaudio-0.9.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.9.1-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-tcWMR2UHe7H8jB9d9tEaZAb2WBhYieou4dmW+JBh9GU=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-0.9.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-0.9.1-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-vxr1Nr0/QGH6Ej+O9bafZOgdplSzRNeRaod4o0EmzhQ=";
    };
  };
}
