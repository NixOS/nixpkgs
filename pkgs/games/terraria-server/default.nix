{ stdenv, lib, file, fetchurl }:
assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name    = "terraria-server-${version}";
  version = "1308";

  src = fetchurl {
    url = http://terraria.org/server/terraria-server-linux-1308.tar.gz;
    sha256 = "0cx3nx7wmzcw9l0nz9zm4amccl8nrd09hlb3jc1yrqcaswbyxc8a";
  };

  buildInputs = [ file ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/terraria-server-linux-${version}/TerrariaServer.bin.x86_64 $out/bin/TerrariaServer

    # Fix "/lib64/ld-linux-x86-64.so.2" like references in ELF executables.
    echo "running patchelf on prebuilt binaries:"
    find "$out" | while read filepath; do
      if file "$filepath" | grep -q "ELF.*executable"; then
        echo "setting interpreter $(cat "$NIX_CC"/nix-support/dynamic-linker) in $filepath"
        patchelf --set-interpreter "$(cat "$NIX_CC"/nix-support/dynamic-linker)" "$filepath"
        test $? -eq 0 || { echo "patchelf failed to process $filepath"; exit 1; }
      fi
    done
  '';

  meta = with lib; {
    homepage = http://terraria.org;
    description = "Dedicated server for the main game";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
