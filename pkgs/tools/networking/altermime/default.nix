{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  baseName = "altermime";
  name = "${baseName}-${version}";
  version = "0.3.10";

  src = fetchurl {
    url = "http://www.pldaniels.com/${baseName}/${name}.tar.gz";
    sha256 = "0vn3vmbcimv0n14khxr1782m76983zz9sf4j2kz5v86lammxld43";
  };

  patches = map fetchurl (import ./debian-patches.nix);

  postPatch = ''
    sed -i Makefile -e "s@/usr/local@$out@"
    mkdir -p "$out/bin"
  '';

  meta = {
    description = "MIME alteration tool";
    maintainers = with stdenv.lib.maintainers; [
      raskin
    ];
    platforms = with stdenv.lib.platforms; linux;
    downloadPage = "http://www.pldaniels.com/altermime/";
  };
}
