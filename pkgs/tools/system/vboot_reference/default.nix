{ stdenv, fetchgit, pkgconfig, libuuid, openssl, libyaml, lzma }:

stdenv.mkDerivation rec {
  version = "20171023";
  checkout = "8122e0b8b13794";

  name = "vboot_reference-${version}";

  src = fetchgit {
    url = https://chromium.googlesource.com/chromiumos/platform/vboot_reference;
    rev = "${checkout}";
    sha256 = "0qxm3qlvm2fgjrn9b3n8rdccw2f5pdi7z542m2hdfddflx7jz1w7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl libuuid libyaml lzma ];

  enableParallelBuilding = true;

  buildPhase = ''
    patchShebangs scripts
    make -j''${NIX_BUILD_CORES:-1} \
         `pwd`/build/cgpt/cgpt \
         `pwd`/build/futility/futility
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/cgpt/cgpt $out/bin
    cp build/futility/futility $out/bin
    mkdir -p $out/share/vboot
    cp -r tests/devkeys* $out/share/vboot/
  '';

  meta = {
    description = "Chrome OS partitioning and kernel signing tools";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.linux;
  };
}
