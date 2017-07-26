{ stdenv, lib, libXScrnSaver, makeWrapper, fetchurl, unzip, atomEnv }:

let
  version = "1.6.6";
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
      sha256 = "1k6y1wcsb2z9h8wdj5f1z1fprvc3bvsj4rfx58if7q74qiq3q102";
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
      sha256 = "1hp42iy32lymh9d5zp4vr51qjrr83wjxmbws0c16yw7zchq7fr64";
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
