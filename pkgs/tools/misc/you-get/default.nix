{ lib, buildPythonApplication, fetchPypi }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1500";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a6cc0d661fe0cd4210bf467d6c89afd8611609e402690254722c1415736da92";
  };

  meta = with lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
    platforms = platforms.all;
  };
}
