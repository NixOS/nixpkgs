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
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "gethomepage";
    repo = "homepage";
    rev = "v${version}";
    hash = "sha256-QPMjf+VpsjvIrjjhDuZqd8VLl2Uu5Wop286Yn8XeRWk=";
  };

  npmDepsHash = "sha256-u15lDdXnV3xlXAC9WQQKLIeV/AgtRM1sFNsacw3j6kU=";

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

    mkdir -p $out/{share,bin}

    cp -r .next/standalone $out/share/homepage/
    cp -r public $out/share/homepage/public

    mkdir -p $out/share/homepage/.next
    cp -r .next/static $out/share/homepage/.next/static

    chmod +x $out/share/homepage/server.js

    makeWrapper $out/share/homepage/server.js $out/bin/homepage \
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
