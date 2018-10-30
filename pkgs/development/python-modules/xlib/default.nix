{ stdenv
, buildPythonPackage
, fetchFromGitHub
, six
, setuptools_scm
, pkgs
}:

buildPythonPackage rec {
  pname = "xlib";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "python-xlib";
    repo = "python-xlib";
    rev = "${version}";
    sha256 = "1iiz2nq2hq9x6laavngvfngnmxbgnwh54wdbq6ncx4va7v98liyi";
  };

  # Tests require `pyutil' so disable them to avoid circular references.
  doCheck = false;

  propagatedBuildInputs = [ six setuptools_scm pkgs.xorg.libX11 ];

  meta = with stdenv.lib; {
    description = "Fully functional X client library for Python programs";
    homepage = http://python-xlib.sourceforge.net/;
    license = licenses.gpl2Plus;
  };

}
