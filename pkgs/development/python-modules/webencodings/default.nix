{ buildPythonPackage
, lib
, fetchurl
, pytest
}:

let
  pname = "webencodings";
  version = "0.5";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "a5c55ee93b24e740fe951c37b5c228dccc1f171450e188555a775261cce1b904";
  };

  buildInputs = [ pytest ];

  checkPhase = ''
    py.test webencodings/tests.py
  '';

  meta = {
    description = "Character encoding aliases for legacy web content";
    homepage = https://github.com/SimonSapin/python-webencodings;
    license = lib.licenses.bsd3;
  };
}