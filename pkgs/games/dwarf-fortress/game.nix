{ stdenv, lib, fetchurl
, SDL, dwarf-fortress-unfuck
}:

let
  baseVersion = "42";
  patchVersion = "06";
  dfVersion = "0.${baseVersion}.${patchVersion}";
  libpath = lib.makeLibraryPath [ stdenv.cc.cc stdenv.glibc dwarf-fortress-unfuck SDL ];

in

assert dwarf-fortress-unfuck.dfVersion == dfVersion;

stdenv.mkDerivation {
  name = "dwarf-fortress-original-${dfVersion}";

  src = fetchurl {
    url = "http://www.bay12games.com/dwarves/df_${baseVersion}_${patchVersion}_linux.tar.bz2";
    sha256 = "17y9zq9xn1g0a501w4vkinb0n2yjiczsi2g7r6zggr41pxrqxpq3";
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    rm $out/libs/lib*

    # Store the original hash
    md5sum $out/libs/Dwarf_Fortress | awk '{ print $1 }' > $out/hash.md5.orig

    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath "${libpath}" \
      $out/libs/Dwarf_Fortress

    # Store the new hash
    md5sum $out/libs/Dwarf_Fortress | awk '{ print $1 }' > $out/hash.md5
  '';

  passthru = { inherit baseVersion patchVersion dfVersion; };

  meta = {
    description = "A single-player fantasy game with a randomly generated adventure world";
    homepage = http://www.bay12games.com/dwarves;
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "i686-linux" ];
    maintainers = with lib.maintainers; [ a1russell robbinch roconnor the-kenny abbradar ];
  };
}
