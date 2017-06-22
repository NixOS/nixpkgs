{ buildPythonPackage
, lib
, fetchurl
, pytest
}:

let
  pname = "webencodings";
  version = "0.5.1";
in buildPythonPackage rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923";
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