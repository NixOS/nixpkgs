{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  baseName = "altermime";
  name = "${baseName}-${version}";
  version = "0.3.11";

  src = fetchurl {
    url = "http://www.pldaniels.com/${baseName}/${name}.tar.gz";
    sha256 = "15zxg6spcmd35r6xbidq2fgcg2nzyv1sbbqds08lzll70mqx4pj7";
  };

  NIX_CFLAGS_COMPILE = [ "-Wno-error=format"
    "-Wno-error=format-truncation"
    "-Wno-error=pointer-compare"
    "-Wno-error=memset-elt-size"
  ];

  postPatch = ''
    sed -i Makefile -e "s@/usr/local@$out@"
    mkdir -p "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "MIME alteration tool";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license.fullName = "alterMIME LICENSE";
    downloadPage = "http://www.pldaniels.com/altermime/";
  };
}
