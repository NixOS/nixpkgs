{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  name = "kwakd-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "fetchinson";
    repo = "kwakd";
    rev = "acdf0e1491204ae30622a60fde0bcae4769f78be";
    sha256 = "1inf9ngrbxmkkdhqf1xday12nf0hxjxlx1810phkmivyyp6fl3nj";
  };

  postInstall = ''
    serviceDir=$out/share/dbus-1/system-services
    mkdir -p $serviceDir
    cp kwakd.service $serviceDir/
    substituteInPlace $serviceDir/kwakd.service \
      --replace "kwakd -p 80" "$out/bin/kwakd -p 80"
  '';

  meta = with lib; {
    description = "A super small webserver that serves blank pages";
    license = licenses.gpl2;
    maintainers = [ maintainers.nicknovitski ];
    platforms = platforms.unix;
  };
}
