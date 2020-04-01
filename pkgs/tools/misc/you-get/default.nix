{ stdenv, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1432";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i3gsl7wk1cn8jw79gnyv58mrrn0hmkvymrd3ic67z2ackp726s2";
  };

  meta = with stdenv.lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
