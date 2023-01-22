{ lib, stdenv, fetchurl, libpng
, static ? stdenv.hostPlatform.isStatic
}:

# This package comes with its own copy of zlib, libpng and pngxtern

with lib;

stdenv.mkDerivation rec {
  pname = "optipng";
  version = "0.7.7";

  src = fetchurl {
    url = "mirror://sourceforge/optipng/optipng-${version}.tar.gz";
    sha256 = "0lj4clb851fzpaq446wgj0sfy922zs5l5misbpwv6w7qrqrz4cjg";
  };

  buildInputs = [ libpng ];

  LDFLAGS = optional static "-static";
  # Workaround for crash in cexcept.h. See
  # https://github.com/NixOS/nixpkgs/issues/28106
  preConfigure = ''
    export LD=$CC
  '';

  configureFlags = [
    "--with-system-zlib"
    "--with-system-libpng"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    #"-prefix=$out"
  ];

  postInstall = if stdenv.hostPlatform != stdenv.buildPlatform && stdenv.hostPlatform.isWindows then ''
    mv "$out"/bin/optipng{,.exe}
  '' else null;

  meta = with lib; {
    homepage = "https://optipng.sourceforge.net/";
    description = "A PNG optimizer";
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
