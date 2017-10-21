{ stdenv, systemd, cryptsetup }:

assert stdenv.isLinux;

stdenv.lib.overrideDerivation systemd (p: {
  version = p.version;
  name = "systemd-cryptsetup-generator";

  nativeBuildInputs = p.nativeBuildInputs ++ [ cryptsetup ];
  outputs = [ "out" ];

  buildPhase = ''
    make $makeFlags built-sources
    make $makeFlags systemd-cryptsetup
    make $makeFlags systemd-cryptsetup-generator
  '';

  # For some reason systemd-cryptsetup-generator is a wrapper-script
  # with the current release of systemd. We want the real one.

  # TODO: Remove `.libs` prefix when the wrapper-script is gone
  installPhase = ''
    mkdir -p $out/lib/systemd/
    cp .libs/systemd-cryptsetup $out/lib/systemd/systemd-cryptsetup
    cp .libs/*.so $out/lib/

    mkdir -p $out/lib/systemd/system-generators/
    cp .libs/systemd-cryptsetup-generator $out/lib/systemd/system-generators/systemd-cryptsetup-generator
  '';
})
