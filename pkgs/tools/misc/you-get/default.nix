{ stdenv, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1025";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d348b89bd4798ef2225f5b357510505a4bc781380479c9f59b69d80ff9a56ab5";
  };

  meta = with stdenv.lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = https://you-get.org;
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
