{ lib, stdenv, fetchurl, freetype, libtool, flex, bison, pkg-config }:

stdenv.mkDerivation {
  pname = "ttf-mkfontdir";
  version = "3.0.9-6";

  src = fetchurl {
    url = "http://mirror.fsf.org/trisquel/pool/main/t/ttmkfdir/ttmkfdir_3.0.9.orig.tar.gz";
    sha256 = "0n6bmmndmp4c1myisvv7cby559gzgvwsw4rfw065a3f92m87jxiq";
  };

  # all the patches up from ttmkfdir-3.0.9/Makefile should be reviewed by someone
  # who knows more about C/C++ ..
  patches =
    [ (fetchurl {
        url = "http://mirror.fsf.org/trisquel/pool/main/t/ttmkfdir/ttmkfdir_3.0.9-6.diff.gz";
        sha256 = "141kxaf2by8nf87hqyszaxi0n7nnmswr1nh2i5r5bsvxxmaj9633";
      })

      ./cstring.patch # also fixes some other compilation issues (freetype includes)
    ];

  # cross-compilation fixes:
  # - fix libtool, the reason it does not work in nativeBuildInputs is complicated
  #   see https://github.com/NixOS/nixpkgs/pull/192878 for more info
  # - freetype-config doesn't properly support cross-compilation, but is just a thin
  #   wrapper around pkg-config anyways
  postPatch = ''
    substituteInPlace Makefile \
      --replace "libtool " "${libtool}/bin/libtool --tag=CXX " \
      --replace "freetype-config" "${stdenv.cc.targetPrefix}pkg-config freetype2"
  '';

  makeFlags = [ "DESTDIR=${placeholder "out"}" "BINDIR=/bin" "CXX=${stdenv.cc.targetPrefix}c++" ];

  nativeBuildInputs = [ flex bison pkg-config ];
  buildInputs = [ freetype ];

  meta = {
    description = "Create fonts.dir for TTF font directory";
    platforms = lib.platforms.linux;
    mainProgram = "ttmkfdir";
  };
}
