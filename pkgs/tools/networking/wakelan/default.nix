{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wakelan";
  version = "1.1";

  src = fetchurl {
    url = "mirror://ibiblioPubLinux/system/network/misc/${pname}-${version}.tar.gz";
    hash = "sha256-PfXrj4d2SHmatiPPFxjsxvhusML1HTRNjoYEQtzFzW8=";
  };

  preInstall = ''
    mkdir -p $out/man/man1 $out/bin
  '';

  meta = {
    description = "Send a wake-on-lan packet";
    longDescription = ''
      WakeLan sends a properly formatted UDP packet across the
      network which will cause a wake-on-lan enabled computer to
      power on.
   '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.unix;
  };
}
