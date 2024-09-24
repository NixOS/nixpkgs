{ stdenv
, lib
, fetchzip
  # can either be "EU" or "Global"; it's unclear what the difference is
, region ? "Global"
  # can be either "English", "French", "German", "Italian", "Portguese" or "Spanish"
, language ? "English"
}:

stdenv.mkDerivation rec {
  pname = "cups-kyocera-ecosys-m2x35-40-p2x35-40dnw";
  version = "8.1606";

  src = let
    urlVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
  in fetchzip {
    url = "https://www.kyoceradocumentsolutions.de/content/download-center/de/drivers/all/Linux_${urlVersion}_ECOSYS_M2x35_40_P2x35_40dnw_zip.download.zip";
    sha256 = "10crxdfj62ini70vv471445zi6q0l9fmg2jsd74sp6fr0qa0kvr7";
  };

  installPhase = ''
    mkdir -p $out/share/cups/model/Kyocera
    cp ${region}/${language}/*.PPD $out/share/cups/model/Kyocera/
  '';

  meta = with lib; {
    description = "PPD files for Kyocera ECOSYS M2040dn/M2135dn/M2540dn/M2540dw/M2635dn/M2635dw/M2640idw/M2735dw/P2040dn/M2040dw/P2235dn/P2235dw";
    homepage = "https://www.kyoceradocumentsolutions.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
