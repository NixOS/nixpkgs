{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "cromfs";
  version = "1.5.10.2";

  src = fetchurl {
    url = "https://bisqwit.iki.fi/src/arch/cromfs-${version}.tar.bz2";
    sha256 = "0xy2x1ws1qqfp7hfj6yzm80zhrxzmhn0w2yns77im1lmd2h18817";
  };

  postPatch = "patchShebangs configure";

  installPhase = ''
    install -d $out/bin
    install cromfs-driver $out/bin
    install util/cvcromfs $out/bin
    install util/mkcromfs $out/bin
    install util/unmkcromfs $out/bin
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse
    perl
  ];

  makeFlags = [ "CXXFLAGS=-std=c++03" ];

  meta = with lib; {
    description = "FUSE Compressed ROM filesystem with lzma";
    homepage = "https://bisqwit.iki.fi/source/cromfs.html";
    license = licenses.gpl3;
    maintainers = [ maintainers.viric ];
    platforms = platforms.linux;
  };
}
