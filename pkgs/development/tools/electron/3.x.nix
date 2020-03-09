{ stdenv, libXScrnSaver, makeWrapper, fetchurl, unzip, atomEnv, gtk2, at-spi2-atk }:

let
  version = "3.1.13";
  name = "electron-${version}";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/electron/electron;
    license = licenses.mit;
    maintainers = with maintainers; [ travisbhartwell manveru ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "i686-linux" "armv7l-linux" "aarch64-linux" ];
  };

  linux = {
    inherit name version meta;
    src = {
      i686-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-ia32.zip";
        sha256 = "04i0rcp4ajp4nf4arcl5crcc7a85sf0ixqd8jx07k2b1irv4dc23";
      };
      x86_64-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
        sha256 = "1psmbplz6jhnnf6hmfhxbmmhn4n1dpnhzbc12pxn645xhfpk9ark";
      };
      armv7l-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-armv7l.zip";
        sha256 = "1pzs2cj12xw18jwab0mb8xhndwd95lbsj5ml5xdw2mb0ip5jsvsa";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-arm64.zip";
        sha256 = "13pc7xn0dkb8i31vg9zplqcvb7r9r7q3inmr3419b5p9bl0687x8";
      };
    }.${stdenv.hostPlatform.system} or throwSystem;

    buildInputs = [ unzip makeWrapper ];

    buildCommand = ''
      mkdir -p $out/lib/electron $out/bin
      unzip -d $out/lib/electron $src
      ln -s $out/lib/electron/electron $out/bin

      fixupPhase

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${atomEnv.libPath}:${gtk2}/lib:${at-spi2-atk}/lib:$out/lib/electron" \
        $out/lib/electron/electron

      wrapProgram $out/lib/electron/electron \
        --prefix LD_PRELOAD : ${stdenv.lib.makeLibraryPath [ libXScrnSaver ]}/libXss.so.1
    '';
  };

  darwin = {
    inherit name version meta;

    src = fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-darwin-x64.zip";
      sha256 = "1vvjm4jifzjqvbs2kjlwg1h9p2czr2b5imjr9hld1j8nyfrzb0dx";
    };

    buildInputs = [ unzip ];

    buildCommand = ''
      mkdir -p $out/Applications
      unzip $src
      mv Electron.app $out/Applications
      mkdir -p $out/bin
      ln -s $out/Applications/Electron.app/Contents/MacOS/Electron $out/bin/electron
    '';
  };
in

  stdenv.mkDerivation (if stdenv.isDarwin then darwin else linux)
