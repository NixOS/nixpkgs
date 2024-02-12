# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version : builtins.getAttr version {
  "2.2.0" = {
    x86_64-linux-38 = {
      name = "torchaudio-2.2.0-cp38-cp38-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.0%2Bcu121-cp38-cp38-linux_x86_64.whl";
      hash = "sha256-POcebL/QW1zrKI53MKygCOElGQn4PB5XRUV50q4UnCo=";
    };
    x86_64-linux-39 = {
      name = "torchaudio-2.2.0-cp39-cp39-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.0%2Bcu121-cp39-cp39-linux_x86_64.whl";
      hash = "sha256-OpwwHNjLB7E3gI6JextkysqRA1kMrQ7GtCNRNmqdwas=";
    };
    x86_64-linux-310 = {
      name = "torchaudio-2.2.0-cp310-cp310-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.0%2Bcu121-cp310-cp310-linux_x86_64.whl";
      hash = "sha256-2zy3mq2qPvY/+WjwqyRXaBrU+fRYwq+NZXnx1K/2Yys=";
    };
    x86_64-linux-311 = {
      name = "torchaudio-2.2.0-cp311-cp311-linux_x86_64.whl";
      url = "https://download.pytorch.org/whl/cu121/torchaudio-2.2.0%2Bcu121-cp311-cp311-linux_x86_64.whl";
      hash = "sha256-d3FY1g5mBPiYWqffYx+m1L8vvmvkWCc3f4pQsuQqZCU=";
    };
    x86_64-darwin-38 = {
      name = "torchaudio-2.2.0-cp38-cp38-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp38-cp38-macosx_10_13_x86_64.whl";
      hash = "sha256-xcsLSJaxB/TR5zR84pY8m7d9JI6KnbWIYWTsobO6Ygo=";
    };
    x86_64-darwin-39 = {
      name = "torchaudio-2.2.0-cp39-cp39-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp39-cp39-macosx_10_13_x86_64.whl";
      hash = "sha256-MdDGWy+jfACwxYL8Kstppyt/9wuBoXVNkAfVYv8UOIA=";
    };
    x86_64-darwin-310 = {
      name = "torchaudio-2.2.0-cp310-cp310-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp310-cp310-macosx_10_13_x86_64.whl";
      hash = "sha256-WeVoNs0r6BlAzrrNP07jd5xLeDeKPmGUVEbad8FjhLQ=";
    };
    x86_64-darwin-311 = {
      name = "torchaudio-2.2.0-cp311-cp311-macosx_10_9_x86_64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp311-cp311-macosx_10_13_x86_64.whl";
      hash = "sha256-lx7enoSIqLhdZySgWGw4KGSHA9gFBU9dEnXTIGDBeUk=";
    };
    aarch64-darwin-38 = {
      name = "torchaudio-2.2.0-cp38-cp38-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp38-cp38-macosx_11_0_arm64.whl";
      hash = "sha256-DQOCmhh+yJOzJT0Rgq8LW+Cak61flOHo3r9iaeHH3NY=";
    };
    aarch64-darwin-39 = {
      name = "torchaudio-2.2.0-cp39-cp39-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp39-cp39-macosx_11_0_arm64.whl";
      hash = "sha256-+xBG66mjt/Z2L2o35EMw3GyWJVAdpL676viWzqQG8tc=";
    };
    aarch64-darwin-310 = {
      name = "torchaudio-2.2.0-cp310-cp310-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp310-cp310-macosx_11_0_arm64.whl";
      hash = "sha256-3Ej5ZswZc6jVipaGM15ResAN2unNe1kpFqBLd0me8rs=";
    };
    aarch64-darwin-311 = {
      name = "torchaudio-2.2.0-cp311-cp311-macosx_11_0_arm64.whl";
      url = "https://download.pytorch.org/whl/cpu/torchaudio-2.2.0-cp311-cp311-macosx_11_0_arm64.whl";
      hash = "sha256-aoRSKkjUYF5C9o5XKcCw6jxaYEyXqjTxC4FH7QEO7gc=";
    };
    aarch64-linux-38 = {
      name = "torchaudio-2.2.0-cp38-cp38-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.2.0-cp38-cp38-linux_aarch64.whl";
      hash = "sha256-GWWTv0PlA/EP+MHGCvqXS19Qtc6yKddAXM7Ke11WAhY=";
    };
    aarch64-linux-39 = {
      name = "torchaudio-2.2.0-cp39-cp39-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.2.0-cp39-cp39-linux_aarch64.whl";
      hash = "sha256-hA64ZbBkfvHBd/fv7hSt0k2vUGKntOSZR/uY1KuZBmM=";
    };
    aarch64-linux-310 = {
      name = "torchaudio-2.2.0-cp310-cp310-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.2.0-cp310-cp310-linux_aarch64.whl";
      hash = "sha256-1OoJS4cho2GYLbBi7pk/Km9x3+FvYqhPiQCyNk8zouQ=";
    };
    aarch64-linux-311 = {
      name = "torchaudio-2.2.0-cp311-cp311-manylinux2014_aarch64.whl";
      url = "https://download.pytorch.org/whl/torchaudio-2.2.0-cp311-cp311-linux_aarch64.whl";
      hash = "sha256-m+GMogoMLoygtjOIcRQIPJKMleRUhwsdbqjP4FmCzsk=";
    };
  };
}
