{ pkgs }:
let
  plugins = import ./composition.nix { inherit pkgs; };
in
plugins // {
  peertube-plugin-transcription = plugins.peertube-plugin-transcription.override {
    buildInputs = [ pkgs.nodePackages.node-gyp-build ];
    dontNpmInstall = true; # otherwise vosk gets removed (?)
    preRebuild = ''
      rm -rf node_modules/vosk/lib
      substituteInPlace node_modules/vosk/index.js \
        --replace '__dirname, "lib", "linux-x86_64"' '"${pkgs.vosk}/lib"'
    '';
    postInstall = ''
      patch -d $out/lib/node_modules/peertube-plugin-transcription -p1 < ${./transcription-cpus.diff}
    '';
  };
}
