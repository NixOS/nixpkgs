{ stdenv, lib, fetchurl, unzip, mesa_glu, libX11, libXext, libXcursor, libXrandr, gcc, alsaLib}:

let
  unlines = strs: lib.concatStrings ((map (x: x + "\n")) strs);

  # the basic extracted binary file and game data 
  tib = 
    stdenv.mkDerivation rec {
      name = "the-infinite-black";

      src = 
        if stdenv.system == "x86_64-linux" 
          then
            fetchurl {
              url = "https://files.spellbook.com/download/tib-unity-linux.zip";
              sha256 = "0cahbbw5d4fg6wirsckcjfwbzgsfb7g1dxngw95ldcdakj7pj5la";
            }
          else throw "incompatible system";

      phases = "unpackPhase installPhase";

      unpackPhase = ''
        unzip $src
      '';

      installPhase = ''
        mkdir -p $out/lib/
        cp -r tib-unity-linux_Data $out/
        cp ./tib-unity-linux.x86_64 $out/
      '';

      buildInputs = [unzip];

      meta =
        { 
          description = "Interesting, free (as in free beer) and very active space-based MMO.";
        };
    };

  # fills the base derivation's resource directory up with 
  # the necessary library files, patch the binary, and make a caller
  # function in $out/bin
  makeConfortable = { deriv, bin, resources }:
    stdenv.mkDerivation rec {
      inherit (deriv) name meta;

      src = deriv;

      phases = "installPhase";

      libs = [mesa_glu libX11 libXext libXcursor libXrandr alsaLib];

      inherit resources bin;

      installPhase = ''
        # copy source tree, fill up resources
        mkdir -p $out
        mkdir -p $out/$resources
        ${unlines (map (lib: "ln -s ${lib}/lib/*.so* $out/$resources/") libs)}

        ln -s ${gcc.cc}/lib/libstdc++.so.6 $out/$resources/

        cp -r $src/* $out/
        
        # patching file
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/$resources $out/$bin

        mkdir $out/bin
        ln -s $out/$bin $out/bin/
      '';
    };
in
  makeConfortable { 
    deriv = tib;
    bin = "tib-unity-linux.x86_64";
    resources = "lib";
  }   
