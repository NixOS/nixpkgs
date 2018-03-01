{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180209.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b85f0e833871408a95619ae38d5344701a6466e8f7b5530e718ccc260b68d3ed";
  };
}
