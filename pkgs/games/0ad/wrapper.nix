{ buildEnv, makeWrapper, zeroad-unwrapped, zeroad-data }:

assert zeroad-unwrapped.version == zeroad-data.version;

buildEnv {
  name = "zeroad-${zeroad-unwrapped.version}";
  inherit (zeroad-unwrapped) meta;

  buildInputs = [ makeWrapper ];

  paths = [ zeroad-unwrapped zeroad-data ];

  pathsToLink = [ "/" "/bin" ];

  postBuild = ''
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --set ZEROAD_ROOTDIR "$out/share/0ad"
    done
  '';
}
