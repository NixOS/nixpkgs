# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.4.0" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.4.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.4.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-HbbFZ4nETaygQRxSMYg6d3Omqxbx6uSrXrUzRt71RTw=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.4.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.4.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-5wG1xXOR9ApLTdWQtt8eGt+83GwT6zfEW+Kay4pz5vQ=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.4.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.4.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-R+F2Pr3UEID6Otlv9OTyKHgxz6jd51IzrRMpxhOr2lA=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.4.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.4.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-KcjEOkm0MDZnvyDNhcP26borSg+0tqrsLgKzstbMbOo=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.4.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.4.0%2Bcu121-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-gTwbojelvYBZo0BOav9xtc09SXmtCV3PreFZJoCFUDE=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.4.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-/D+OzW8Lv8ZU07xSdWp8o1nx2ItPoCkOHNt2OjExt7k=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.4.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-H9ZwyAjjIsEBlXoHZR4pk1+G7DiSQ8DEOiTt16GFSEE=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.4.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-cz6dhZuI2r7+rwCOOrK4x4hbKUZgaLS3mkJ2a+RhnkY=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.4.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-rLz5Ep/8/OgIJU4sv/EDNjxQXOBu1MQjGz9DahBnnU0=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.4.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-rhOpXvb6vK2w7/NthfUEjXBHSi6XBPqchumQPLzsDUo=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.4.0-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-1/6efy/oJQ/eB7IDVsRNdw1fqjyid6vc2jr31IQEj7o=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.4.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-yECJTeEqbdPqV8uw0AhhI6qkgAG6Otme9xT+AJ6ujrk=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.4.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-F8tz1DNncdRVzY3ai0iRMHpTRriQpOax1Lc9VlJY/uE=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.4.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-vpacCUZts14Nebiwnf9myu27lWm0LJA6LV4Nsq92Djw=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.4.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.4.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-U00ZB7slLs0rqeHWHP9yIP1mCQ5j33s8EJzqd6GdTLg=";
    };
  };
}
