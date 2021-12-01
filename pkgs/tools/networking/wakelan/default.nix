{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "wakelan";
  version = "1.1";

  src = fetchurl {
    url = "mirror://metalab/system/network/misc/wakelan-${version}.tar.gz";
    sha256 = "0vydqpf44146ir6k87gmqaq6xy66xhc1gkr3nsd7jj3nhy7ypx9x";
  };

  preInstall = ''
    mkdir -p $out/man/man1 $out/bin
  '';

  meta = {
    description = "Send a wake-on-lan packet";

    longDescription =
      '' WakeLan sends a properly formatted UDP packet across the
         network which will cause a wake-on-lan enabled computer to
         power on.
      '';

    license = lib.licenses.gpl2Plus;

    maintainers = [ lib.maintainers.viric ];
    platforms = lib.platforms.unix;
  };
}
