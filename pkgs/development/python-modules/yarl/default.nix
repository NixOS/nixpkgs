{ lib
, fetchurl
, buildPythonPackage
, multidict
, pytestrunner
, pytest
}:

let
  pname = "yarl";
  version = "0.13.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "25fe681a982f2cec567df8abac7cbd2ac27016e4aec89193945cab0643bfdb42";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict ];


  meta = {
    description = "Yet another URL library";
    homepage = https://github.com/aio-libs/yarl/;
    license = lib.licenses.asl20;
  };
}