{
  buildNpmPackage,
  fetchFromGitHub,
  nodePackages,
  python3,
  stdenv,
  cctools,
  IOKit,
  lib,
  nixosTests,
  enableLocalIcons ? false,
  nix-update-script,
}:
let
  dashboardIcons = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "dashboard-icons";
    rev = "51a2ae7b101c520bcfb5b44e5ddc99e658bc1e21"; # Until 2025-01-06
    hash = "sha256-rKXeMAhHV0Ax7mVFyn6hIZXm5RFkbGakjugU0DG0jLM=";
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
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "gethomepage";
    repo = "homepage";
    rev = "v${version}";
    hash = "sha256-q8+uoikHMQVuTrVSH8tPsoI5655ZStMc/7tmoAfoZIY=";
  };

  npmDepsHash = "sha256-N39gwct2U4UxlIL5ceDzzU7HpA6xh2WksrZNxGz04PU=";

  preBuild = ''
    mkdir -p config
  '';

  postBuild = ''
    # Add a shebang to the server js file, then patch the shebang.
    sed -i '1s|^|#!/usr/bin/env node\n|' .next/standalone/server.js
    patchShebangs .next/standalone/server.js
  '';

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  buildInputs = [
    nodePackages.node-gyp-build
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ IOKit ];

  env.PYTHON = "${python3}/bin/python";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,bin}

    cp -r .next/standalone $out/share/homepage/
    cp -r public $out/share/homepage/public

    mkdir -p $out/share/homepage/.next
    cp -r .next/static $out/share/homepage/.next/static

    chmod +x $out/share/homepage/server.js

    # This patch must be applied here, as it's patching the `dist` directory
    # of NextJS. Without this, homepage-dashboard errors when trying to
    # write its prerender cache.
    #
    # This patch ensures that the cache implementation respects the env
    # variable `NIXPKGS_HOMEPAGE_CACHE_DIR`, which is set by default in the
    # wrapper below.
    (cd "$out" && patch -p1 <${./prerender_cache_path.patch})

    makeWrapper $out/share/homepage/server.js $out/bin/homepage \
      --set-default PORT 3000 \
      --set-default HOMEPAGE_CONFIG_DIR /var/lib/homepage-dashboard \
      --set-default NIXPKGS_HOMEPAGE_CACHE_DIR /var/cache/homepage-dashboard

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
    description = "Highly customisable dashboard with Docker and service API integrations";
    changelog = "https://github.com/gethomepage/homepage/releases/tag/v${version}";
    mainProgram = "homepage";
    homepage = "https://gethomepage.dev";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
