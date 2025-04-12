{
  buildEnv,
  makeWrapper,
  zeroad-unwrapped,
  zeroad-data,
}:

assert zeroad-unwrapped.version == zeroad-data.version;

buildEnv {
  name = "zeroad-${zeroad-unwrapped.version}";

  nativeBuildInputs = [ makeWrapper ];

  paths = [
    zeroad-unwrapped
    zeroad-data
  ];

  pathsToLink = [
    "/"
    "/bin"
  ];

  postBuild = ''
    for i in $out/bin/*; do
      wrapProgram "$i" \
        --set ZEROAD_ROOTDIR "$out/share/0ad"
    done
  '';

  meta = zeroad-unwrapped.meta // {
    hydraPlatforms = [ ];
  };
}
