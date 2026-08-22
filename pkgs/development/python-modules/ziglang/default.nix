{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ziglang";
  version = "0.16.0";
  format = "wheel";
  __structuredAttrs = true;

  # not sure how to build this from source: https://codeberg.org/ziglang/zig https://codeberg.org/ziglang/zig-pypi
  src = fetchPypi {
    inherit pname version format;
    hash = "sha256-n82nP2K4Ud1ypUtxCtQKIJiW2xTPsTZJ5iGRJDVWNCs=";
    dist = "py3";
    python = "py3";
    platform = "manylinux_2_12_x86_64.manylinux2010_x86_64.musllinux_1_1_x86_64";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Zig is a general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    homepage = "https://ziglang.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
