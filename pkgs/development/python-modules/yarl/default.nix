{ lib
, fetchurl
, buildPythonPackage
, multidict
, pytestrunner
, pytest
}:

let
  pname = "yarl";
  version = "0.12.0";
in buildPythonPackage rec {
  name = "${pname}-${version}";
  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "fc0f71ffdce882b4d4b287b0b3a68d9f2557ab14cc2c10ce4df714c42512cbde";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ multidict ];


  meta = {
    description = "Yet another URL library";
    homepage = https://github.com/aio-libs/yarl/;
    license = lib.licenses.asl20;
  };
}