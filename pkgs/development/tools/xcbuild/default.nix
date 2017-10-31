{ stdenv, cmake, fetchFromGitHub, zlib, libxml2, libpng, CoreServices, CoreGraphics, ImageIO, ninja }:

let
  googletest = fetchFromGitHub {
    owner  = "google";
    repo   = "googletest";
    rev    = "43359642a1c16ad3f4fc575c7edd0cb935810815";
    sha256 = "0y4xaah62fjr3isaryc3vfz3mn9xflr00vchdimj8785milxga4q";
  };

  linenoise = fetchFromGitHub {
    owner  = "antirez";
    repo   = "linenoise";
    rev    = "c894b9e59f02203dbe4e2be657572cf88c4230c3";
    sha256 = "0wasql7ph5g473zxhc2z47z3pjp42q0dsn4gpijwzbxawid71b4w";
  };
in stdenv.mkDerivation rec {
  name    = "xcbuild-${version}";

  # Once a version is released that includes https://github.com/facebook/xcbuild/commit/183c087a6484ceaae860c6f7300caf50aea0d710,
  # we can stop doing this -pre thing.
  version = "0.1.2-pre";

  src = fetchFromGitHub {
    owner  = "facebook";
    repo   = "xcbuild";
    rev    = "32b9fbeb69bfa2682bd0351ec2f14548aaedd554";
    sha256 = "1xxwg2849jizxv0g1hy0b1m3i7iivp9bmc4f5pi76swsn423d41m";
  };

  prePatch = ''
    rmdir ThirdParty/*
    cp -r --no-preserve=all ${googletest} ThirdParty/googletest
    cp -r --no-preserve=all ${linenoise} ThirdParty/linenoise
  '';

  # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
  postPatch = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    sed 1i'#include <sys/sysmacros.h>' \
      -i Libraries/xcassets/Headers/xcassets/Slot/SystemVersion.h
  '';

  enableParallelBuilding = true;

  # TODO: instruct cmake not to put it in /usr, rather than cleaning up
  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=strict-aliasing";

  cmakeFlags = [ "-GNinja" ];

  buildInputs = [ cmake zlib libxml2 libpng ninja ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreServices CoreGraphics ImageIO ];

  meta = with stdenv.lib; {
    description = "Xcode-compatible build tool";
    homepage = https://github.com/facebook/xcbuild;
    platforms = platforms.unix;
    maintainers = with maintainers; [ copumpkin matthewbauer ];
  };
}
