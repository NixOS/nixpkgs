{ lib
, fetchFromGitHub
, buildGoModule
, fetchYarnDeps
, stdenv
, yarn
, nodejs
, git
, fixup_yarn_lock
}:

buildGoModule rec {
  pname = "alice-lg";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "alice-lg";
    repo = "alice-lg";
    rev = version;
    hash = "sha256-BdhbHAFqyQc8UbVm6eakbVmLS5QgXhr06oxoc6vYtsM=";
  };

  vendorHash = "sha256-SNF46uUTRCaa9qeGCfkHBjyo4BWOlpRaTDq+Uha08y8=";

  passthru.ui = stdenv.mkDerivation {
    pname = "alice-lg-ui";
    src = "${src}/ui";
    inherit version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/ui/yarn.lock";
      hash = "sha256-NeK9IM8E2IH09SVH9lMlV3taCmqwlroo4xzmv4Q01jI=";
    };

    nativeBuildInputs = [ nodejs yarn git ];
    configurePhase = ''
      runHook preConfigure

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock

      yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
      patchShebangs node_modules/
      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      ./node_modules/.bin/react-scripts build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mv build $out

      runHook postInstall
    '';
  };

  preBuild = ''
    cp -R ${passthru.ui}/ ui/build/
  '';

  subPackages = [ "cmd/alice-lg" ];
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/alice-lg/alice-lg";
    description = "A looking-glass for BGP sessions";
    changelog = "https://github.com/alice-lg/alice-lg/blob/main/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ janik ];
  };
}
