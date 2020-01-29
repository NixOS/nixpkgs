{ stdenv, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1355";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06y9q336az8dzkxc13rzhl0m6l298saaida75wsd9fjm8pych6fx";
  };

  meta = with stdenv.lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = https://you-get.org;
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
