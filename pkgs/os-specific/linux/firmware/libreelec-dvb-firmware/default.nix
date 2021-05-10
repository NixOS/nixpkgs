{ stdenv, fetchFromGitHub, lib}:

stdenv.mkDerivation rec {
  pname = "libreelec-dvb-firmware";
  version = "1.4.2";

  src = fetchFromGitHub {
    repo = "dvb-firmware";
    owner = "LibreElec";
    rev = version;
    sha256 = "1xnfl4gp6d81gpdp86v5xgcqiqz2nf1i43sb3a4i5jqs8kxcap2k";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/lib
    cp -rv firmware $out/lib
    find $out/lib \( -name 'README.*' -or -name 'LICEN[SC]E.*' -or -name '*.txt' \) | xargs rm
  '';

  meta = with lib; {
    description = "DVB firmware from LibreELEC";
    homepage = "https://github.com/LibreELEC/dvb-firmware";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ kittywitch ];
    platforms = platforms.linux;
  };
}
