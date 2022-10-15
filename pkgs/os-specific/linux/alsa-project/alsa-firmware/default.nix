{ lib, buildPackages, stdenvNoCC, autoreconfHook, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "alsa-firmware";
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://alsa/firmware/alsa-firmware-${version}.tar.bz2";
    sha256 = "sha256-tnttfQi8/CR+9v8KuIqZwYgwWjz1euLf0LzZpbNs1bs=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ autoreconfHook ];

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

  meta = with lib; {
    homepage = "http://www.alsa-project.org/";
    description = "Soundcard firmwares from the alsa project";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ l-as ];
  };
}
