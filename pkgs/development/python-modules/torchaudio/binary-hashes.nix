# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "2.6.0" = {
    x86_64-linux-39 = {
      name = "torchaudio-2.6.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchaudio-2.6.0%2Bcu124-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-EYTNqjrjUTXZGDw+ionYOeQU6ioUu8qrDIgzNpq7WvY=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.6.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchaudio-2.6.0%2Bcu124-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-a1T5f/+WtLo9pEtrP1ByfCUSLRR5EHsRnRJ1lE7IPqE=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.6.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchaudio-2.6.0%2Bcu124-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-uMFdfg6BojYwot5VLrrP5mQ5kNyJD4P0JuQ/9i7+hlE=";
    };
    x86_64-linux-312 = {
      name = "torchaudio-2.6.0-cp312-cp312-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchaudio-2.6.0%2Bcu124-cp312-cp312-linux_x86_64.whl";
      hash = "sha256-Pl/6aWBhccdPPiuWl4Xq1Qt4LKZX50aq7h7nzIjc/Ag=";
    };
    x86_64-linux-313 = {
      name = "torchaudio-2.6.0-cp313-cp313-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu124/torchaudio-2.6.0%2Bcu124-cp313-cp313-linux_x86_64.whl";
      hash = "sha256-G8I5Y/RHyRCgBgsTCwS0B9LqIYsqVT5nTIKdXxfrjI4=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.6.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-BIA6lpcQvbd6Td/bhaMvqbngMQ3JH3635U1gg91pv6s=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.6.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-Dtoc2Hb0T8AU3ASqaA2y+jVag99dg0OY223V9c2RH0w=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.6.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-wS/EEkG43848zBkX8cgaD5L1MtmRdwZgAEbx6yHS12U=";
    };
    aarch64-darwin-312 = {
      name = "torchaudio-2.6.0-cp312-cp312-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp312-cp312-macosx_11_0_arm64.whl";
      hash = "sha256-fQ5LCMQjJb9LiH3polxE7YgplwAXQOG9fZAfZVgc8as=";
    };
    aarch64-darwin-313 = {
      name = "torchaudio-2.6.0-cp313-cp313-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-ZvLgvVq1b9gUGdL1r7dKmnAUFohZRkZEF1bIwk9CSnM=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.6.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-cudwVdjnQkdcbfrPWfqwmx/JTUQj4UiX4Yi2fK04UcY=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.6.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-nY4HeJRS79uBMtYq/iHyKTpygF8mwokcbFPk5N843fY=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.6.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-Dw21yZfQMcNAZti+HAzn0qHytsAWqSiFsgsAv+sXt1M=";
    };
    aarch64-linux-312 = {
      name = "torchaudio-2.6.0-cp312-cp312-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp312-cp312-linux_aarch64.whl";
      hash = "sha256-YpHZUH3B1rT/6IQ/v7IB5sgnDdjEKtcLt2ImwOvcrVY=";
    };
    aarch64-linux-313 = {
      name = "torchaudio-2.6.0-cp313-cp313-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.6.0-cp313-cp313-linux_aarch64.whl";
      hash = "sha256-tSHqlhj7TCmm+AcWKBcMIiKR9GpIo79CTP60iPVK9xQ=";
    };
  };
}
