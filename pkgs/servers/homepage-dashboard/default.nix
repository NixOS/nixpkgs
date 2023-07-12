{ buildNpmPackage
, fetchFromGitHub
, nodePackages
, python3
, lib
, fetchpatch
, makeBinaryWrapper
, nixosTests
}:

buildNpmPackage rec {
  pname = "homepage-dashboard";
  version = "0.6.21";

  src = fetchFromGitHub {
    owner = "benphelps";
    repo = "homepage";
    rev = "v${version}";
    hash = "sha256-kjxA02hJj/GAQ0fM1xTtXAnZSQgVyE+EMRrXis1Vr+o=";
  };

  npmDepsHash = "sha256-O6SQYx5vxscMsbWv0ynUYqdUkOp/nMtdvlZ/Mp95sBY=";

  patches = [
    (fetchpatch {
      name = "env-config-dir.patch";
      url = "https://github.com/benphelps/homepage/commit/ca396ce96bce52f6c06a321f292aa94a66ceeb97.patch";
      hash = "sha256-eNnW/ce4ytoKR6jH1Ztc4UTWOmL0uGRdY6nYBIVYM6k=";
    })
  ];

  preBuild = ''
    mkdir -p config
  '';

  postBuild = ''
    # Add a shebang to the server js file, then patch the shebang.
    sed -i '1s|^|#!/usr/bin/env node\n|' .next/standalone/server.js
    patchShebangs .next/standalone/server.js
  '';

  buildInputs = [
    nodePackages.node-gyp-build
  ];

  env.PYTHON = "${python3}/bin/python";

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r .next/standalone $out/bin
    cp -r public $out/bin/public

    mkdir -p $out/bin/.next
    cp -r .next/static $out/bin/.next/static

    mv $out/bin/server.js $out/bin/homepage
    chmod +x $out/bin/homepage

    wrapProgram $out/bin/homepage \
      --set-default PORT 3000 \
      --set-default HOMEPAGE_CONFIG_DIR /var/lib/homepage-dashboard

    runHook postInstall
  '';

  doDist = false;

  passthru.tests = {
    inherit (nixosTests) homepage;
  };

  meta = {
    description = "A highly customisable dashboard with Docker and service API integrations.";
    mainProgram = "homepage";
    homepage = "https://gethomepage.dev";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.all;
  };
}
