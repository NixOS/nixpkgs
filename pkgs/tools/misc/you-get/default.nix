{ lib, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1536";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "78c9a113950344e06d18940bd11fe9a2f78b9d0bc8963cde300017ac1ffcef09";
  };

  meta = with lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
