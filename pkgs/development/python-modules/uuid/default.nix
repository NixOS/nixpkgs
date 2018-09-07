{ lib, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "uuid";
  version = "1.30";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gqrjsm85nnkxkmd1vk8350wqj2cigjflnvcydk084n5980cr1qz";
  };

  meta = with lib; {
    description = "UUID object and generation functions (Python 2.3 or higher)";
    homepage = http://zesty.ca/python/;
  };
}
