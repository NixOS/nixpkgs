{ stdenv, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1475";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "432c04170bb5f4881ca6af9c802b6c90e81759811487b8d7918762dcd674697f";
  };

  meta = with stdenv.lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
