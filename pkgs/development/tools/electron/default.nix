{ stdenv, lib, libXScrnSaver, makeWrapper, fetchurl, unzip, atomEnv }:

let
  version = "1.4.15";
  name = "electron-${version}";

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/electron/electron;
    license = licenses.mit;
    maintainers = [ maintainers.travisbhartwell ];
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
  };

  linux = {
    inherit name version meta;

    src = fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
      sha256 = "07b9jdbjrf3siv205wd1dphq6ly0hkaapzvj87d2yjfiyzv3cbsl";
      name = "${name}.zip";
    };

    buildInputs = [ unzip makeWrapper ];

    buildCommand = ''
      mkdir -p $out/lib/electron $out/bin
      unzip -d $out/lib/electron $src
      ln -s $out/lib/electron/electron $out/bin

      fixupPhase

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:$out/lib/electron" \
        $out/lib/electron/electron

      wrapProgram $out/lib/electron/electron \
        --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1
    '';
  };

  darwin = {
    inherit name version meta;

    src = fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-darwin-x64.zip";
      sha256 = "0p8gkyq4qczzia26wrnbs91vdqzxhgq515cmsrwvhw87mc9fka4k";
      name = "${name}.zip";
    };

    buildInputs = [ unzip ];

    buildCommand = ''
    mkdir -p $out/Applications
    unzip $src
    mv Electron.app $out/Applications
    mkdir -p $out/bin
    ln -s $out/Applications/Electron.app/Contents/MacOs/Electron $out/bin/electron
    '';
  };
in

  stdenv.mkDerivation (if stdenv.isDarwin then darwin else linux)
