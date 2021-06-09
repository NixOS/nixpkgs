{ lib, stdenv, buildPackages, autoreconfHook, fetchurl }:

stdenv.mkDerivation rec {
  pname = "alsa-firmware";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://alsa/firmware/${pname}-${version}.tar.bz2";
    sha256 = "1fymdjrsbndws3gy4ypm7id31261k65bh2pzyrz29z5w11ynsyxn";
  };

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
    homepage = "http://www.alsa-project.org/";
    description = "Soundcard firmwares from the alsa project";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
