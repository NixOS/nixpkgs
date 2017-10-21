{ stdenv, lib, file, fetchurl, unzip }:
assert stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name    = "terraria-server-${version}";
  version = "1.3.1.1";
  urlVersion = lib.replaceChars ["."] [""] version;

  src = fetchurl {
    url = "http://terraria.org/server/terraria-server-${urlVersion}.zip";
    sha256 = "0bwh0na0dy6cjc1xchd5sp3c7av50q38hk03219dmqd72n9p44rq";
  };

  buildInputs = [ file unzip ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r Linux $out/
    chmod +x "$out/Linux/TerrariaServer.bin.x86_64"
    ln -s "$out/Linux/TerrariaServer.bin.x86_64" $out/bin/TerrariaServer
    # Fix "/lib64/ld-linux-x86-64.so.2" like references in ELF executables.
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
    description = "Dedicated server for Terraria, a 2D action-adventure sandbox";
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}
