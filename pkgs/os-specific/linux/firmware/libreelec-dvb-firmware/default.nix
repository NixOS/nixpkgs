{ stdenvNoCC, fetchFromGitHub, lib}:

stdenvNoCC.mkDerivation rec {
  pname = "libreelec-dvb-firmware";
  version = "1.4.2";

  src = fetchFromGitHub {
    repo = "dvb-firmware";
    owner = "LibreElec";
    rev = version;
    sha256 = "1xnfl4gp6d81gpdp86v5xgcqiqz2nf1i43sb3a4i5jqs8kxcap2k";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -rv firmware $out/lib
    find $out/lib \( -name 'README.*' -or -name 'LICEN[SC]E.*' -or -name '*.txt' \) | xargs rm

    runHook postInstall
  '';

  meta = with lib; {
    description = "DVB firmware from LibreELEC";
    homepage = "https://github.com/LibreELEC/dvb-firmware";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ kittywitch ];
    platforms = platforms.linux;
  };
}
