{ lib
, fetchurl
, buildPythonPackage
, multidict
, pytestrunner
, pytest
}:

let
  pname = "yarl";
  version = "0.10.2";
in buildPythonPackage rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "a042c5b3584531cd09cd5ca647f71553df7caaa3359b9b3f7eb34c3b1045b38d";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict ];


  meta = {
    description = "Yet another URL library";
    homepage = https://github.com/aio-libs/yarl/;
    license = lib.licenses.asl20;
  };
}