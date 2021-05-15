{ lib, stdenv, cmake, fetchFromGitHub, zlib, libxml2, libpng
, CoreServices, CoreGraphics, ImageIO, ninja }:

let
  googletest = fetchFromGitHub {
    owner  = "google";
    repo   = "googletest";
    rev    = "a2b8a8e07628e5fd60644b6dd99c1b5e7d7f1f47";
    sha256 = "1jhxgx8vcf9nfrj82336q773x44hd8vmgkx0l6mcrqymxdwqv00w";
  };

  linenoise = fetchFromGitHub {
    owner  = "antirez";
    repo   = "linenoise";
    rev    = "c894b9e59f02203dbe4e2be657572cf88c4230c3";
    sha256 = "0wasql7ph5g473zxhc2z47z3pjp42q0dsn4gpijwzbxawid71b4w";
  };
in stdenv.mkDerivation {
  pname = "xcbuild";

  # The project has been archived on github, we build the last available revision
  version = "archived";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "xcbuild";
    rev    = "dbaee552d2f13640773eb1ad3c79c0d2aca7229c";
    sha256 = "05ypbvrxrda2k1jhhwf4jg69510pglp9qrhp43jz4lwn22wx4szf";
  };

  prePatch = ''
    rmdir ThirdParty/*
    cp -r --no-preserve=all ${googletest} ThirdParty/googletest
    cp -r --no-preserve=all ${linenoise} ThirdParty/linenoise
  '';

  patches = [
    # add a missing `<cstdlib>` import
    # Failure: https://hydra.nixos.org/build/142008015/nixlog/2
    ./add-missing-import.patch
  ];

  postPatch = lib.optionalString (!stdenv.isDarwin) ''
    # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
    sed 1i'#include <sys/sysmacros.h>' \
      -i Libraries/xcassets/Headers/xcassets/Slot/SystemVersion.h
  '' + lib.optionalString stdenv.isDarwin ''
    # Apple Open Sourced LZFSE, but not libcompression, and it isn't
    # part of an impure framework we can add
    substituteInPlace Libraries/libcar/Sources/Rendition.cpp \
      --replace "#if HAVE_LIBCOMPRESSION" "#if 0"
  '';

  # TODO: instruct cmake not to put it in /usr, rather than cleaning up
  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
    cp liblinenoise.* $out/lib/
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error";

  cmakeFlags = [ "-GNinja" ];

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ zlib libxml2 libpng ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices CoreGraphics ImageIO ];

  meta = with lib; {
    description = "Xcode-compatible build tool";
    homepage = "https://github.com/facebook/xcbuild";
    platforms = platforms.unix;
    maintainers = with maintainers; [ copumpkin matthewbauer ];
    license = with licenses; [ bsd2 bsd3 ];
  };
}
