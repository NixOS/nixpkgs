{ lib, stdenv, fetchurl, perl }:
stdenv.mkDerivation rec {
  version = "2.0.0.2";
  pname = "checkbashisms";

  src = fetchurl {
    url = "mirror://sourceforge/project/checkbaskisms/${version}/checkbashisms";
    sha256 = "1vm0yykkg58ja9ianfpm3mgrpah109gj33b41kl0jmmm11zip9jd";
  };

  buildInputs = [ perl ];

  # The link returns directly the script. No need for unpacking
  dontUnpack = true;

  installPhase = ''
    install -D -m755 $src $out/bin/checkbashisms
  '';

  meta = {
    homepage = "https://sourceforge.net/projects/checkbaskisms/";
    description = "Check shell scripts for non-portable syntax";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}
