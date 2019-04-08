{ stdenv
, buildPythonPackage
, fetchPypi
, darcsver
}:

buildPythonPackage rec {
  pname = "setuptools_darcs";
  version = "1.2.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wsh0g1fn10msqk87l5jrvzs0yj5mp6q9ld3gghz6zrhl9kqzdn1";
  };

  # In order to break the dependency on darcs -> ghc, we don't add
  # darcs as a propagated build input.
  propagatedBuildInputs = [ darcsver ];

  # ugly hack to specify version that should otherwise come from darcs
  patchPhase = ''
    substituteInPlace setup.py --replace "name=PKG" "name=PKG, version='${version}'"
  '';

  meta = with stdenv.lib; {
    description = "Setuptools plugin for the Darcs version control system";
    homepage = http://allmydata.org/trac/setuptools_darcs;
    license = licenses.bsd0;
  };
}
