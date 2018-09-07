{ stdenv, systemd, cryptsetup }:

systemd.overrideAttrs (p: {
  version = p.version;
  name = "systemd-cryptsetup-generator-${p.version}";

  buildInputs = p.buildInputs ++ [ cryptsetup ];
  outputs = [ "out" ];

  buildPhase = ''
    ninja systemd-cryptsetup systemd-cryptsetup-generator
  '';

  # As ninja install is not used here, the rpath needs to be manually fixed.
  # Otherwise the resulting binary doesn't properly link against systemd-shared.so
  postFixup = ''
    sharedLib=libsystemd-shared-${p.version}.so
    for prog in `find $out -type f -executable`; do
      (patchelf --print-needed $prog | grep $sharedLib > /dev/null) && (
        patchelf --set-rpath `patchelf --print-rpath $prog`:"$out/lib/systemd" $prog
      ) || true
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/systemd/
    cp systemd-cryptsetup $out/lib/systemd/systemd-cryptsetup
    cp src/shared/*.so $out/lib/systemd/

    mkdir -p $out/lib/systemd/system-generators/
    cp systemd-cryptsetup-generator $out/lib/systemd/system-generators/systemd-cryptsetup-generator
  '';
})
