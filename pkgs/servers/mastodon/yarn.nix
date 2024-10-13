{
  stdenvNoCC,
  yarn-berry,
  cacert,
  version,
  src,
  hash,
}:
stdenvNoCC.mkDerivation {
  pname = "yarn-deps";
  inherit version src;

  nativeBuildInputs = [
    yarn-berry
  ];

  dontInstall = true;

  NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildPhase = ''
    export HOME=$(mktemp -d)
    export YARN_ENABLE_TELEMETRY=0

    cache="$(yarn config get cacheFolder)"
    yarn install --immutable --mode skip-build

    mkdir -p $out
    cp -r $cache/* $out/
  '';

  outputHash = hash;
  outputHashMode = "recursive";
}
