{ lib, stdenv, fetchurl, cpio, xar, undmg, libtapi, DiskArbitration }:

stdenv.mkDerivation rec {
  pname = "macfuse-stubs";
  version = "4.8.0";

  src = fetchurl {
    url = "https://github.com/osxfuse/osxfuse/releases/download/macfuse-${version}/macfuse-${version}.dmg";
    hash = "sha256-ucTzO2qdN4QkowMVvC3+4pjEVjbwMsB0xFk+bvQxwtQ=";
  };

  nativeBuildInputs = [ cpio xar undmg libtapi ];
  propagatedBuildInputs = [ DiskArbitration ];

  postUnpack = ''
    xar -xf 'Install macFUSE.pkg'
    cd Core.pkg
    gunzip -dc Payload | cpio -i
  '';

  sourceRoot = ".";

  buildPhase = ''
    pushd usr/local/lib
    for f in *.dylib; do
      tapi stubify --filetype=tbd-v2  "$f" -o "''${f%%.dylib}.tbd"
    done
    sed -i "s|^prefix=.*|prefix=$out|" pkgconfig/fuse.pc
    popd
  '';

  # NOTE: Keep in mind that different parts of macFUSE are distributed under a
  # different license
  installPhase = ''
    mkdir -p $out/include $out/lib/pkgconfig
    cp usr/local/lib/*.tbd $out/lib
    cp usr/local/lib/pkgconfig/*.pc $out/lib/pkgconfig
    cp -R usr/local/include/* $out/include
  '';

  meta = with lib; {
    homepage = "https://osxfuse.github.io";
    description = "Build time stubs for FUSE on macOS";
    longDescription = ''
      macFUSE is required for this package to work on macOS. To install macFUSE,
      use the installer from the <link xlink:href="https://osxfuse.github.io/">
      project website</link>.
    '';
    platforms = platforms.darwin;
    maintainers = with maintainers; [ midchildan ];

    # macFUSE as a whole includes code with restrictions on commercial
    # redistribution. However, the build artifacts that we actually touch for
    # this derivation are distributed under a free license.
    license = with licenses; [
      lgpl2Plus # libfuse
    ];
  };

  passthru.warning = ''
    macFUSE is required for this package to work on macOS. To install macFUSE,
    use the installer from the <link xlink:href="https://osxfuse.github.io/">
    project website</link>.
  '';
}
