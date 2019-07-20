{ stdenv, fetchurl }:

let
  version = "2.5.1";
in stdenv.mkDerivation rec {
  name = "libgnurx-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/mingw/Other/UserContributed/regex/mingw-regex-${version}/mingw-${name}-src.tar.gz";
    sha256 = "0xjxcxgws3bblybw5zsp9a4naz2v5bs1k3mk8dw00ggc0vwbfivi";
  };

  meta = {
    platforms = stdenv.lib.platforms.windows;
  };
}
