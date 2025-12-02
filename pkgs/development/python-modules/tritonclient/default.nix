{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  numpy,
  python-rapidjson,
  # optional dependencies
  aiohttp,
  geventhttpclient,
  grpcio,
  packaging,
}:

let
  pname = "tritonclient";
  version = "2.54.0";
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
        aarch64-linux = "e485a67c75121a2b58456bd6275086252dd72208674b0c85bd57a60f428b686f";
        x86_64-linux = "53c326498e9036f99347a938d52abd819743e957223edec31ae3c9681e5a6065";
      };
    in
    fetchPypi {
      inherit pname version format;
      python = "py3";
      dist = "py3";
      platform =
        platforms.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      sha256 =
        hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    };

  propagatedBuildInputs = [
    numpy
    python-rapidjson
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

  meta = with lib; {
    description = "Triton Python client";
    homepage = "https://github.com/triton-inference-server/client";
    license = licenses.bsd3;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.linux;
  };
}
