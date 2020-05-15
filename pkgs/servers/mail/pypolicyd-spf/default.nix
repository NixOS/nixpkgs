{ lib, buildPythonApplication, fetchurl, pyspf }:

buildPythonApplication rec {
  pname = "pypolicyd-spf";
  majorVersion = "2.0";
  version = "${majorVersion}.2";

  src = fetchurl {
    url = "https://launchpad.net/pypolicyd-spf/${majorVersion}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "1nm8y1jjgx6mxrbcxrbdnmkf8vglwp0wiw6jipzh641wb24gi76z";
  };

  propagatedBuildInputs = [ pyspf ];

  preBuild = ''
    substituteInPlace setup.py --replace "'/etc'" "'$out/etc'"
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/pypolicyd-spf/";
    description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
