{
  lib,
  buildPythonPackage,
  fetchurl,
  stdenv,
}:

buildPythonPackage rec {
  pname = "scipy-openblas32";
  version = "0.3.30.0.8";
  format = "wheel";

  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://files.pythonhosted.org/packages/b5/3f/aec7efb933e4c11206b54757316448bc593207d12dcb3b1f25e70df43111/scipy_openblas32-0.3.30.0.8-py3-none-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
          hash = "sha256-s+mAGFq32VnHXH8PSbFSCeyFQ0oJFE9sv+OkX6gltDY=";
        };
      }
      ."${stdenv.hostPlatform.system}"
        or (throw "Unsupported system for ${pname}: ${stdenv.hostPlatform.system}");

  meta = {
    changelog = "https://github.com/MacPython/openblas-libs/releases/tag/${version}";
    description = "Provides OpenBLAS for python packaging";
    homepage = "https://github.com/MacPython/openblas-libs";
    license = lib.licenses.bsd2;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      anderscs
    ];
  };
}
