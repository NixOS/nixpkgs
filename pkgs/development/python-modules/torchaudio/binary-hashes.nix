# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.1.1" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.1.1-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.1%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-GM8TlEbiLP2K+jglzkkvPPEf00LxcI7o9K+EtIKLTGA=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.1.1-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.1%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-4YdH1mdew+TFmvpA23Lp5+pNcVy5KxQ9pV31lhPAPTA=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.1.1-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.1%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-7/gmDgL4imlKlksrtvY3pq8xB3h9kH6uflgBgWAzv6c=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.1.1-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.1.1%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-qq2dkQ5CDBlVsIpa8yatlplLitDQWW/L9gGxVYDof6c=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.1.1-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-b8d8SNB5zSbvQMYTqm8xxcePD4FiEWYqJ4Vsf1RPHMw=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.1.1-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-f/BYndc9vepm7SHIF8ttHvjs0+6EmXrqf8DjUroWjkg=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.1.1-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-JPpYcPYgmU5FiEUtVO3LL/tfUJ1+42ugToxo6yiv/Io=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.1.1-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-7j9/B9sCOprjYGpjDbRyJ+d/IOYEyZQGdnzsWKE5uW4=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.1.1-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-L+SgvGuooE9xrLxmT93CtzY3y/G+NFxkM0KprtNDVDo=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.1.1-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-VwmUP7JnXIVDvrYfAz+50AGr8VXxUJrzPhO8uD9UPQo=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.1.1-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-fNRlvgb9OHNq2n1MCG8M3SSd4ot1ddEDXOJd+ziW+kw=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.1.1-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.1.1-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-+tHGDPveoxu7KgDk0fFTYEYG3N00vJdPQ8YvpuJpYns=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.1.1-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.1-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-bnhAF5QfPoGtvvJGIkqT1eXSZocF3NxFlWZo3nuiLTI=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.1.1-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.1-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-FXE1qdeNwSe7J0XEZUqn6hQd3Huzn8rSHf+Oq6VXihQ=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.1.1-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.1-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-dK3UoOX6BJmO1SoBN9Ox2cKtJdqCEsRt8O1z+h0Uanc=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.1.1-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.1.1-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-6toEKY1TfF0CddoRIsRxmMF31CYetaXSI24Rqg6FyB8=";
    };
  };
}
