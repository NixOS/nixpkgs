{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "alsa-firmware-1.2.1";

  src = fetchurl {
    url = "mirror://alsa/firmware/${name}.tar.bz2";
    sha256 = "1aq8z8ajpjvcx7bwhwp36bh5idzximyn77ygk3ifs0my3mbpr8mf";
  };

  configureFlags = [
    "--with-hotplug-dir=$(out)/lib/firmware"
  ];

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
    homepage = http://www.alsa-project.org/;
    description = "Soundcard firmwares from the alsa project";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
