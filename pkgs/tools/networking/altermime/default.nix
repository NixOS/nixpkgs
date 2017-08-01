{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  baseName = "altermime";
  name = "${baseName}-${version}";
  version = "0.3.11";

  src = fetchurl {
    url = "http://www.pldaniels.com/${baseName}/${name}.tar.gz";
    sha256 = "15zxg6spcmd35r6xbidq2fgcg2nzyv1sbbqds08lzll70mqx4pj7";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=format";

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
