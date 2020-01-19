{ stdenv, buildPythonPackage, fetchPypi, python3Packages }:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.13.0";

  checkInputs = [ python3Packages.hypothesis ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q9msi00s93iqm8vzd839r7yc51gz54z90h5bckqyjdxa6vxijz5";
  };
}
