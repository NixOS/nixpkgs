{ stdenv, fetchurl, perl }:
stdenv.mkDerivation rec {
  inherit perl;

  name = "checkbashisms";
  version = "2.0.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/checkbaskisms/${version}/${name}";
    sha256 = "1vm0yykkg58ja9ianfpm3mgrpah109gj33b41kl0jmmm11zip9jd";
  };

  # The link returns directly the script. No need for unpacking
  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/checkbashisms
    chmod 755 $out/bin/checkbashisms
  '';

  # Makes sure to point to the proper perl version
  fixupPhase = ''
    sed -e "s#/usr/bin/perl#$perl/bin/perl#" -i $out/bin/checkbashisms
  '';

  meta = {
    homepage = http://sourceforge.net/projects/checkbaskisms/;
    description = "Check shell scripts for non-portable syntax";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
