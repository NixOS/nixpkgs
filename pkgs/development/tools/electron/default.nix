{ stdenv, callPackage, fetchurl, unzip
, ...
} @ args:

let
  atomEnv = callPackage ./env-atom.nix (args);
in stdenv.mkDerivation rec {
  name = "electron-${version}";
  version = "0.36.2";

  src = fetchurl {
    url = "https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
    sha256 = "01d78j8dfrdygm1r141681b3bfz1f1xqg9vddz7j52z1mlfv9f1d";
    name = "${name}.zip";
  };

  buildInputs = [ atomEnv unzip ];

  phases = [ "installPhase" "fixupPhase" ];

  unpackCmd = "unzip";

  installPhase = ''
    mkdir -p $out/bin
    unzip -d $out/bin $src
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    $out/bin/electron
  '';

  postFixup = ''
    patchelf \
    --set-rpath "${atomEnv}/lib:${atomEnv}/lib64:$out/bin:$(patchelf --print-rpath $out/bin/electron)" \
    $out/bin/electron
  '';

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/atom/electron;
    license = licenses.mit;
    maintainers = [ maintainers.travisbhartwell ];
    platforms = [ "x86_64-linux" ];
  };
}
