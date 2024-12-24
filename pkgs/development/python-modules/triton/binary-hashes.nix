# Warning: Need to update at the same time as torch-bin
#
# Precompiled wheels can be found at:
# https://download.pytorch.org/whl/torch_stable.html

# To add a new version, run "prefetch.sh 'new-version'" to paste the generated file as follows.

version:
builtins.getAttr version {
  "3.1.0" = {
    x86_64-linux-38 = {
      name = "triton-3.1.0-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-3.1.0-cp38-cp38-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      hash = "sha256-ba2sp/wk3jThgCcbXPhkwWdVcC6fY6FvYt9xSoCZEmo=";
    };
    x86_64-linux-39 = {
      name = "triton-3.1.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl ";
      url = "https://download.pytorch.org/whl/triton-3.1.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      hash = "sha256-qvqaIM0Nn+5SPNRQSqcTGAeoZM133Pbv5+mB8YuMbBE=";
    };
    x86_64-linux-310 = {
      name = "triton-3.1.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl ";
      url = "https://download.pytorch.org/whl/triton-3.1.0-cp310-cp310-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      hash = "sha256-aw3RCpJSY6u+n6N9zeZ6Xpsjg/wmn99Z9WV8rDjF0dg=";
    };
    x86_64-linux-311 = {
      name = "triton-3.1.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-3.1.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      hash = "sha256-DzT254hdG/Dqr3uodaXwzm88E7qY+VA2UcHm3GdX7Vw=";
    };
    x86_64-linux-312 = {
      name = "triton-3.1.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      url = "https://download.pytorch.org/whl/triton-3.1.0-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      hash = "sha256-yBgvQv2AgKfTnWZoFPo2xeMMwA6n7usaKYPbtMmaD9w=";
    };
  };
}
