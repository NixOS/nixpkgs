{ stdenv, lib, fetchurl
, SDL, dwarf-fortress-unfuck

# Our own "unfuck" libs for macOS
, ncurses, fmodex, gcc

, dfVersion, df-hashes
}:

with lib;

let
  libpath = makeLibraryPath [ stdenv.cc.cc stdenv.cc.libc dwarf-fortress-unfuck SDL ];

  homepage = http://www.bay12games.com/dwarves/;

  # Map Dwarf Fortress platform names to Nixpkgs platform names.
  # Other srcs are avilable like 32-bit mac & win, but I have only
  # included the ones most likely to be needed by Nixpkgs users.
  platforms = {
    x86_64-linux = "linux";
    i686-linux = "linux32";
    x86_64-darwin = "osx";
    i686-darwin = "osx32";
    x86_64-cygwin = "win";
    i686-cygwin = "win32";
  };

  dfVersionTriple = splitVersion dfVersion;
  baseVersion = elemAt dfVersionTriple 1;
  patchVersion = elemAt dfVersionTriple 2;

  game = if hasAttr dfVersion df-hashes
         then getAttr dfVersion df-hashes
         else throw "Unknown Dwarf Fortress version: ${dfVersion}";
  dfPlatform = if hasAttr stdenv.hostPlatform.system platforms
               then getAttr stdenv.hostPlatform.system platforms
               else throw "Unsupported system: ${stdenv.hostPlatform.system}";
  sha256 = if hasAttr dfPlatform game
           then getAttr dfPlatform game
           else throw "Unsupported dfPlatform: ${dfPlatform}";

in

stdenv.mkDerivation {
  name = "dwarf-fortress-${dfVersion}";

  src = fetchurl {
    url = "${homepage}df_${baseVersion}_${patchVersion}_${dfPlatform}.tar.bz2";
    inherit sha256;
  };

  installPhase = ''
    mkdir -p $out
    cp -r * $out
    rm $out/libs/lib*

    exe=$out/${if stdenv.isLinux then "libs/Dwarf_Fortress"
                                 else "dwarfort.exe"}

    # Store the original hash
    md5sum $exe | awk '{ print $1 }' > $out/hash.md5.orig
  '' + optionalString stdenv.isLinux ''
    patchelf \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      --set-rpath "${libpath}" \
      $exe
  '' + optionalString stdenv.isDarwin ''
    # My custom unfucked dwarfort.exe for macOS. Can't use
    # absolute paths because original doesn't have enough
    # header space. Someone plz break into Tarn's house & put
    # -headerpad_max_install_names into his LDFLAGS.

    ln -s ${getLib ncurses}/lib/libncurses.dylib $out/libs
    ln -s ${getLib gcc.cc}/lib/libstdc++.6.dylib $out/libs
    ln -s ${getLib fmodex}/lib/libfmodex.dylib $out/libs

    install_name_tool \
      -change /usr/lib/libncurses.5.4.dylib \
              @executable_path/libs/libncurses.dylib \
      -change /usr/local/lib/x86_64/libstdc++.6.dylib \
              @executable_path/libs/libstdc++.6.dylib \
      $exe
  '' + ''
    # Store the new hash
    md5sum $exe | awk '{ print $1 }' > $out/hash.md5
  '';

  passthru = {
    inherit baseVersion patchVersion dfVersion;
    updateScript = ./update.sh;
  };

  meta = {
    description = "A single-player fantasy game with a randomly generated adventure world";
    inherit homepage;
    license = licenses.unfreeRedistributable;
    platforms = attrNames platforms;
    maintainers = with maintainers; [ a1russell robbinch roconnor the-kenny abbradar numinit shazow ];
  };
}
