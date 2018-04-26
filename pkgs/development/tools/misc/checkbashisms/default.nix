{ stdenv, fetchurl, perl }:
stdenv.mkDerivation rec {
  version = "2.18.2";
  name = "checkbashisms-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/devscripts/devscripts_${version}.tar.xz";
    sha256 = "0dflfy94bycqsymszpbia3biypk4kiniz4zi7m7iz7bspqa5hnv4";
  };

  buildInputs = [ perl ];

  # The link returns directly the script. No need for unpacking
  unpackPhase = "true";

  installPhase = ''
    install -D -m755 $src $out/bin/checkbashisms
  '';

  meta = {
    homepage = https://sourceforge.net/projects/checkbaskisms/;
    description = "Check shell scripts for non-portable syntax";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
