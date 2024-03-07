{ buildNpmPackage
, fetchFromGitHub
, nodePackages
, python3
, stdenv
, cctools
, IOKit
, lib
, fetchpatch
, makeBinaryWrapper
, nixosTests
}:

buildNpmPackage rec {
  pname = "homepage-dashboard";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "gethomepage";
    repo = "homepage";
    rev = "v${version}";
    hash = "sha256-WjyOpR8DcjlJJgUkWortc0ApgpusknTSeVQlSa5rCRQ=";
  };

  npmDepsHash = "sha256-RC2Y4XZqO+mLEKQxq+j2ukZYi/uu9XIjYadxek9P+SM=";

  preBuild = ''
    mkdir -p config
  '';

  postBuild = ''
    # Add a shebang to the server js file, then patch the shebang.
    sed -i '1s|^|#!/usr/bin/env node\n|' .next/standalone/server.js
    patchShebangs .next/standalone/server.js
  '';

  nativeBuildInputs = lib.optionals stdenv.isDarwin [
    cctools
  ];

  buildInputs = [
    nodePackages.node-gyp-build
  ] ++ lib.optionals stdenv.isDarwin [
    IOKit
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
    inherit (nixosTests) homepage-dashboard;
  };

  meta = {
    description = "A highly customisable dashboard with Docker and service API integrations.";
    mainProgram = "homepage";
    homepage = "https://gethomepage.dev";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.all;
    broken = stdenv.isDarwin;
  };
}
