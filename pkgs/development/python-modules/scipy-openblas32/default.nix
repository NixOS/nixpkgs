{
  lib,
  buildPythonPackage,
  fetchurl,
  stdenv,
}:

buildPythonPackage rec {
  pname = "scipy-openblas32";
  version = "0.3.30.359.2";
  format = "wheel";

  # Since this is intended to be a binary distribution of openblas for python
  # it makes sense to use the prebuilt binaries. Building from source did not work "out-of-the-box".
  src =
    fetchurl
      {
        x86_64-linux = {
          url = "https://files.pythonhosted.org/packages/aa/66/3d5349b60dd0178030c23788d841e91b64b7f3263869040599682474feaa/scipy_openblas32-0.3.30.359.2-py3-none-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
          hash = "sha256-WQ6tOHlB+dng+Z3hJSGNFs3gCad5/nj0yqK167D/Ddo=";
        };
        x86_64-darwin = {
          url = "https://files.pythonhosted.org/packages/39/c6/36b8b41e165258fe2b038ba204be58596385b92309fc2b2f9166d80d04ac/scipy_openblas32-0.3.30.359.2-py3-none-macosx_10_9_x86_64.whl";
          hash = "sha256-qDsFi336n1DO7q5pTXi8FI1Szk6nVjmexBdAyZ5VA94=";
        };
        aarch64-linux = {
          url = "https://files.pythonhosted.org/packages/4c/33/ae05f376af203677b9b4efe289f41c4489e4cfe4c7b49700e004459eb603/scipy_openblas32-0.3.30.359.2-py3-none-manylinux2014_aarch64.manylinux_2_17_aarch64.whl";
          hash = "sha256-SVHWXNUVUZkS7050iGvlAFilzjDQjOBwUGRMLoNlQOc=";
        };
        aarch64-darwin = {
          url = "https://files.pythonhosted.org/packages/94/a8/e61228a776a91db01e4846d8d7a02349261a714b8569742b859c06c55572/scipy_openblas32-0.3.30.359.2-py3-none-macosx_11_0_arm64.whl";
          hash = "sha256-AkxHWzPzmIIsSP3YxO0t5OQRtzbgtIZG7O0g02ulOis=";
        };
      }
      ."${stdenv.hostPlatform.system}"
        or (throw "Unsupported system for ${pname}: ${stdenv.hostPlatform.system}");

  meta = {
    changelog = "https://github.com/MacPython/openblas-libs/releases/tag/${version}";
    description = "Provides OpenBLAS for python packaging";
    homepage = "https://github.com/MacPython/openblas-libs";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      anderscs
    ];
  };
}
