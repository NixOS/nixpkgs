{ stdenv, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1270";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gq6z605xfhgama11krsc8y0qr690dgf9x39q2z941bqdxvxra5g";
  };

  meta = with stdenv.lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = https://you-get.org;
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
