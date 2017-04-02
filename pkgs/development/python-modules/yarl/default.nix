{ lib
, fetchurl
, buildPythonPackage
, multidict
, pytestrunner
, pytest
}:

let
  pname = "yarl";
  version = "0.8.1";
in buildPythonPackage rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "9f0397ae540124bf16a8a5b89bc3ea1c07f8ae70c3e44231a40a9edd254d5712";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict ];


  meta = {
    description = "Yet another URL library";
    homepage = https://github.com/aio-libs/yarl/;
    license = lib.licenses.asl20;
  };
}