{ stdenv, buildPackages, autoreconfHook, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "alsa-firmware-1.2.1";

  src = fetchurl {
    url = "mirror://alsa/firmware/${name}.tar.bz2";
    sha256 = "1aq8z8ajpjvcx7bwhwp36bh5idzximyn77ygk3ifs0my3mbpr8mf";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/alsa-project/alsa-firmware/commit/a8a478485a999ff9e4a8d8098107d3b946b70288.patch";
    sha256 = "0zd7vrgz00hn02va5bkv7qj2395a1rl6f8jq1mwbryxs7hiysb78";
  }) ];

  nativeBuildInputs = [ autoreconfHook buildPackages.stdenv.cc ];

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
