{ buildNpmPackage
, fetchFromGitHub
, nodePackages
, python3
, stdenv
, cctools
, IOKit
, lib
, nixosTests
, enableLocalIcons ? false
, nix-update-script
}:
let
  dashboardIcons = fetchFromGitHub {
    owner = "walkxcode";
    repo = "dashboard-icons";
    rev = "a02a5999fe56948671721da8b0830cdd5b609ed7"; # Until 2024-02-25
    hash = "sha256-s0Doh4j6CH66fZoQKMt4yc7aLStNFGMVoDp5dvs7+pk=";
  };

  installLocalIcons = ''
    mkdir -p $out/share/homepage/public/icons
    cp ${dashboardIcons}/png/* $out/share/homepage/public/icons
    cp ${dashboardIcons}/svg/* $out/share/homepage/public/icons
    cp ${dashboardIcons}/LICENSE $out/share/homepage/public/icons/
  '';
in
buildNpmPackage rec {
  pname = "homepage-dashboard";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "gethomepage";
    repo = "homepage";
    rev = "v${version}";
    hash = "sha256-4nSlL4m0SL3B7+lI/BGt1aY1UE46la7/4NU4BaJ7EwQ=";
  };

  npmDepsHash = "sha256-jYZUVwrOxoAbfHHSBkN5IlYhC6yZVVwRoZErkbYrjUs=";

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

    ${if enableLocalIcons then installLocalIcons else ""}

    runHook postInstall
  '';

  doDist = false;

  passthru = {
    tests = {
      inherit (nixosTests) homepage-dashboard;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A highly customisable dashboard with Docker and service API integrations";
    changelog = "https://github.com/gethomepage/homepage/releases/tag/v${version}";
    mainProgram = "homepage";
    homepage = "https://gethomepage.dev";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.all;
    broken = stdenv.isDarwin;
  };
}
