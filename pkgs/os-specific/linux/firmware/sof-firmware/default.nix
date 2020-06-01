{ stdenv, fetchurl }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "sof-firmware";
  version = "1.4.2";

  src = fetchurl {
    url = "https://www.alsa-project.org/files/pub/misc/sof/${pname}-${version}.tar.bz2";
    sha256 = "1nkh020gjm45vxd6fvmz63hj16ilff2nl5avvsklajjs6xci1sf5";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    rm lib/firmware/intel/{sof/LICENCE,sof-tplg/LICENCE}
    mkdir $out
    cp -r lib $out/lib
  '';

  meta = with stdenv.lib; {
    description = "Sound Open Firmware";
    homepage = "https://www.sofproject.org/";
    license = with licenses; [ bsd3 isc ];
    maintainers = with maintainers; [ lblasc ];
    platforms = with platforms; linux;
  };
}
