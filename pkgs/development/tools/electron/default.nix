{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv, xorg }:

stdenv.mkDerivation rec {
  name = "electron-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
    sha256 = "0jqzs1297f6w7s4j9pd7wyyqbidb0c61yjz47raafslg6nljgp1c";
    name = "${name}.zip";
  };

  buildInputs = [ unzip ];

  buildCommand = ''
    mkdir -p $out/lib/electron $out/bin
    unzip -d $out/lib/electron $src
    ln -s $out/lib/electron/electron $out/bin

    fixupPhase

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${atomEnv.libPath}:${xorg.libXScrnSaver}/lib:${xorg.libXScrnSaver}/lib64:$out/lib/electron" \
      $out/lib/electron/electron
  '';

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/atom/electron;
    license = licenses.mit;
    maintainers = [ maintainers.travisbhartwell ];
    platforms = [ "x86_64-linux" ];
  };
}
