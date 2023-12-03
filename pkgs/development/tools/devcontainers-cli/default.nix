{
  lib,
  stdenv,
  fetchzip,
  nodejs_18
}:
let
  pname = "devcontainers-cli";
  version = "0.54.1";
  hash = "sha256-L6sVDmKuFmrf9Bm9M54ABmmWFVB8ZlqU+5gAeITBS1Q=";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    inherit hash;
    url = "https://registry.npmjs.org/@devcontainers/cli/-/cli-${version}.tgz";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a "$src/." "$out"
    rm devcontainer.js
  '';

  postFixup = ''
    cat <<EOF > $out/bin/devcontainer
    #!${nodejs_18}/bin/node
      require('$out/dist/spec-node/devContainersSpecCLI');
    EOF

    chmod +x $out/bin/devcontainer
  '';

  meta = with lib; {
    homepage = "https://containers.dev";
    description = "A reference implementation for the specification that can create and configure a dev container from a devcontainer.json";
    license = licenses.mit;
    platforms = lib.intersectLists (lib.platforms.linux) (lib.platforms.x86_64);
    maintainers = with maintainers; [ mr360 ];
  };
}
