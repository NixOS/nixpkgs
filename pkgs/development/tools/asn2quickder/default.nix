{ stdenv, fetchFromGitHub, python2Packages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "asn2quickder";
  name = "${pname}-${version}";
  version = "0.7-RC1";

  src = fetchFromGitHub {
    sha256 = "0ynajhbml28m4ipbj5mscjcv6g1a7frvxfimxh813rhgl0w3sgq8";
    rev = "version-${version}";
    owner = "vanrein";
    repo = "${pname}";
  };

  propagatedBuildInputs = with python2Packages; [ pyparsing makeWrapper ];

  patchPhase = with python2Packages; ''
    substituteInPlace Makefile \
      --replace '..' '..:$(DESTDIR)/${python.sitePackages}:${python2Packages.pyparsing}/${python.sitePackages}' \
    '';

  installPhase = ''
    mkdir -p $out/${python2Packages.python.sitePackages}/
    mkdir -p $out/bin $out/lib $out/sbin $out/man
    make DESTDIR=$out PREFIX=/ all
    make DESTDIR=$out PREFIX=/ install
    '';

  meta = with stdenv.lib; {
    description = "An ASN.1 compiler with a backend for Quick DER";
    homepage = https://github.com/vanrein/asn2quickder;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };
}
