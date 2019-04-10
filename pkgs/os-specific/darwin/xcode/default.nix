{ stdenv, requireFile, lib }:

let requireXcode = version: sha256:
  let
    xip = "Xcode_" + version +  ".xip";
    # TODO(alexfmpe): Find out how to validate the .xip signature in Linux
    unxip = if stdenv.isDarwin
            then ''
              open -W ${xip}
              rm -rf ${xip}
            ''
            else ''
              xar -xf ${xip}
              rm -rf ${xip}
              pbzx -n Content | cpio -i
              rm Content Metadata
            '';
    app = requireFile rec {
      name     = "Xcode.app";
      url      = "https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_${version}/${xip}";
      hashMode = "recursive";
      inherit sha256;
      message  = ''
        Unfortunately, we cannot download ${name} automatically.
        Please go to ${url}
        to download it yourself, and add it to the Nix store by running the following commands.
        Note: download (~ 5GB), extraction and storing of Xcode will take a while

        ${unxip}
        nix-store --add-fixed --recursive sha256 Xcode.app
        rm -rf Xcode.app
      '';
    };
    meta = with stdenv.lib; {
      homepage = https://developer.apple.com/downloads/;
      description = "Apple's XCode SDK";
      license = licenses.unfree;
      platforms = platforms.darwin ++ platforms.linux;
    };

  in app.overrideAttrs ( oldAttrs: oldAttrs // { inherit meta; });

in lib.makeExtensible (self: {
  xcode_8_1 = requireXcode "8.1" "18xjvfipwzia66gm3r9p770xdd4r375vak7chw5vgqnv9yyjiq2n";
  xcode_8_2 = requireXcode "8.2" "13nd1zsfqcp9hwp15hndr0rsbb8rgprrz7zr2ablj4697qca06m2";
  xcode_9_1 = requireXcode "9.1" "0ab1403wy84ys3yn26fj78cazhpnslmh3nzzp1wxib3mr1afjvic";
  xcode_9_2 = requireXcode "9.2" "1bgfgdp266cbbqf2axcflz92frzvhi0qw0jdkcw6r85kdpc8dj4c";
  xcode_9_4 = requireXcode "9.4" "132l92c702lm8yrc62w4b8n2iap1qzqvklqzi39x9832ajysn6vw";
  xcode_10_1 = requireXcode "10.1" "1ssdbg4v8r11fjf4jl38pwyry2aia1qihbxyxapz0v0n5gfnp05v";
  xcode = self."xcode_${lib.replaceStrings ["."] ["_"] (if stdenv.targetPlatform.useiOSPrebuilt then stdenv.targetPlatform.xcodeVer else "8.2")}";
})
