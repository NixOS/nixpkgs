{ stdenv, systemd, cryptsetup }:

assert stdenv.isLinux;

stdenv.lib.overrideDerivation systemd (p: {
  version = p.version;
  name = "systemd-cryptsetup-generator";

  nativeBuildInputs = p.nativeBuildInputs ++ [ cryptsetup ];
  outputs = [ "out" ];

  buildPhase = ''
    ninja systemd-cryptsetup systemd-cryptsetup-generator
  '';

  installPhase = ''
    mkdir -p $out/lib/systemd/
    cp systemd-cryptsetup $out/lib/systemd/systemd-cryptsetup
    cp src/shared/*.so $out/lib/systemd/

    mkdir -p $out/lib/systemd/system-generators/
    cp systemd-cryptsetup-generator $out/lib/systemd/system-generators/systemd-cryptsetup-generator
  '';
})
