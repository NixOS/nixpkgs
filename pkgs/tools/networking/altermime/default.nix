{ lib, gccStdenv, fetchurl }:

gccStdenv.mkDerivation rec {
  pname = "altermime";
  version = "0.3.11";

  src = fetchurl {
    url = "https://pldaniels.com/${pname}/${pname}-${version}.tar.gz";
    sha256 = "15zxg6spcmd35r6xbidq2fgcg2nzyv1sbbqds08lzll70mqx4pj7";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=format"
    "-Wno-error=format-truncation"
    "-Wno-error=pointer-compare"
    "-Wno-error=memset-elt-size"
    "-Wno-error=restrict"
  ];

  postPatch = ''
    mkdir -p $out/bin
    substituteInPlace Makefile --replace "/usr/local" "$out"
  '';

  meta = with lib; {
    description = "MIME alteration tool";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.all;
    license.fullName = "alterMIME LICENSE";
    downloadPage = "https://pldaniels.com/altermime/";
  };
}
