{ lib, buildPythonApplication, fetchurl, pyspf, dnspython, authres, pymilter }:

buildPythonApplication rec {
  pname = "spf-engine";
  majorVersion = lib.versions.majorMinor version;
  version = "2.9.3";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/${majorVersion}/${version}/+download/${pname}-${version}.tar.gz";
    sha256 = "sha256-w0Nb+L/Os3KPApENoylxCVaCD4FvgmvpfVvwCkt2IDE=";
  };

  propagatedBuildInputs = [ pyspf dnspython authres pymilter ];

  preBuild = ''
    substituteInPlace setup.py --replace "'/etc'" "'$out/etc'"
  '';

  meta = with lib; {
    homepage = "https://launchpad.net/${pname}/";
    description = "Postfix policy engine for Sender Policy Framework (SPF) checking";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
