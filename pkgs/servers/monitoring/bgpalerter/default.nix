{ stdenv, pkgs, lib, fetchFromGitHub, makeWrapper, buildEnv, nodejs, nodePackages }:

stdenv.mkDerivation rec {
  name = "bgpalerter";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "nttgin";
    repo = "BGPalerter";
    rev = "v${version}";
    sha256 = "sha256-Y0atkJfZxjUOGPQ3goXS/YD5SsX9ZjpbM0Nc5IuaFP4=";
  };

  nativeBuildInputs = [ makeWrapper nodejs ];

  buildDependencies = with nodePackages; [
    nodePackages."@babel/cli"
    nodePackages."@babel/core"
    nodePackages."@babel/node"
    nodePackages."@babel/plugin-proposal-class-properties"
    nodePackages."@babel/plugin-proposal-object-rest-spread"
    nodePackages."@babel/plugin-transform-async-to-generator"
    nodePackages."@babel/preset-env"
    chai
    chai-subset
    mocha
    pkg
    read-last-lines
    syslogd
  ];

  runtimeDependencies = with nodePackages; [
    nodePackages."@sentry/node"
    axios
    batch-promises
    brembo
    deepmerge
    fast-file-logger
    https-proxy-agent
    inquirer
    ip-sub
    js-yaml
    kafkajs
    md5
    moment
    nodemailer
    path
    restify
    rpki-validator
    semver
    syslog-client
    ws
    yargs
  ];

  buildNode = buildEnv {
    name = "bgpalerter-dev";
    paths = buildDependencies ++ runtimeDependencies;
  };
  runtimeNode = buildEnv {
    name = "bgpalerter-runtime";
    paths = runtimeDependencies;
  };

  buildPhase = ''
    runHook preBuild

    ln -s ${buildNode}/lib/node_modules node_modules
    export NODE_PATH="${buildNode}/lib/node_modules"
    npm run compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r dist $out/share/bgpalerter

    makeWrapper '${nodejs}/bin/node' "$out/bin/bgpalerter" \
      --set NODE_PATH "${runtimeNode}/lib/node_modules" \
      --add-flags "$out/share/bgpalerter/index.js"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Self-configuring BGP monitoring tool";
    homepage = "https://github.com/nttgin/BGPalerter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zhaofengli ];
  };
}
