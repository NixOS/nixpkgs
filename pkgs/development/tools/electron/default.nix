{ stdenv, lib, callPackage, fetchurl, unzip, atomEnv }:

stdenv.mkDerivation rec {
  name = "electron-${version}";
  version = "0.36.2";

  src = fetchurl {
    url = "https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
    sha256 = "01d78j8dfrdygm1r141681b3bfz1f1xqg9vddz7j52z1mlfv9f1d";
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
      --set-rpath "${atomEnv.libPath}:$out/lib/electron" \
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
