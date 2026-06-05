{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  numpy,
  python-rapidjson,
  urllib3,
  # optional dependencies
  aiohttp,
  geventhttpclient,
  grpcio,
  packaging,
}:

let
  pname = "tritonclient";
  version = "2.68.0";
  format = "wheel";
in
buildPythonPackage rec {
  inherit pname version format;

  src =
    let
      platforms = {
        aarch64-linux = "manylinux2014_aarch64";
        x86_64-linux = "manylinux1_x86_64";
      };
      hashes = {
        aarch64-linux = "sha256-RkHdD4yPvo85Fqts07XFsgiMUCFXWiWuHQqfGDznJGk=";
        x86_64-linux = "sha256-7h98H/ipZk56193fhhaSR62Mnis4Wakn/ZhOrhWa4vc=";
      };
    in
    fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      platform =
        platforms.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      hash =
        hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    };

  propagatedBuildInputs = [
    numpy
    python-rapidjson
    urllib3
  ];

  pythonImportsCheck = [ "tritonclient" ];

  passthru = {
    optional-dependencies = {
      http = [
        aiohttp
        geventhttpclient
      ];
      grpc = [
        grpcio
        packaging
      ];
    };
  };

  meta = {
    description = "Triton Python client";
    homepage = "https://github.com/triton-inference-server/client";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.linux;
  };
}
