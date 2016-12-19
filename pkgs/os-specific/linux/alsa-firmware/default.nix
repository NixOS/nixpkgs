{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "alsa-firmware-1.0.29";

  src = fetchurl {
    urls = [
      "ftp://ftp.alsa-project.org/pub/firmware/${name}.tar.bz2"
      "http://alsa.cybermirror.org/firmware/${name}.tar.bz2"
    ];
    sha256 = "0gfcyj5anckjn030wcxx5v2xk2s219nyf99s9m833275b5wz2piw";
  };

  configureFlags = ''
    --with-hotplug-dir=$(out)/lib/firmware
  '';

  dontStrip = true;

  postInstall = ''
    # These are lifted from the Arch PKGBUILD
    # remove files which conflicts with linux-firmware
    rm -rf $out/lib/firmware/{ct{efx,speq}.bin,ess,korg,sb16,yamaha}
    # remove broken symlinks (broken upstream)
    rm -rf $out/lib/firmware/turtlebeach
    # remove empty dir
    rm -rf $out/bin
  '';

  meta = {
    homepage = http://www.alsa-project.org/main/index.php/Main_Page;
    description = "Soundcard firmwares from the alsa project";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
