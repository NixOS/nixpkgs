{ lib
, fetchFromGitHub
, buildGoModule
, fetchYarnDeps
, stdenv
, yarn
, nodejs
, nixosTests
, fixup-yarn-lock
}:

buildGoModule rec {
  pname = "alice-lg";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "alice-lg";
    repo = "alice-lg";
    rev = version;
    hash = "sha256-BbwTLHDtpa8HCECIiy+UxyQiLf9iAD2GzE0azXk7QGU=";
  };

  vendorHash = "sha256-8N5E1CW5Z7HujwXRsZLv7y4uNOJkjj155kmX9PCjajQ=";

  passthru.ui = stdenv.mkDerivation {
    pname = "alice-lg-ui";
    src = "${src}/ui";
    inherit version;

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/ui/yarn.lock";
      hash = "sha256-PwByNIegKYTOT8Yg3nDMDFZiLRVkbX07z99YaDiBsIY=";
    };

    nativeBuildInputs = [ nodejs yarn fixup-yarn-lock ];
    configurePhase = ''
      runHook preConfigure

      # Yarn and bundler wants a real home directory to write cache, config, etc to
      export HOME=$NIX_BUILD_TOP/fake_home

      # Make yarn install packages from our offline cache, not the registry
      yarn config --offline set yarn-offline-mirror $yarnOfflineCache

      # Fixup "resolved"-entries in yarn.lock to match our offline cache
      fixup-yarn-lock yarn.lock

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

  passthru.tests = nixosTests.alice-lg;

  meta = with lib; {
    homepage = "https://github.com/alice-lg/alice-lg";
    description = "A looking-glass for BGP sessions";
    changelog = "https://github.com/alice-lg/alice-lg/blob/main/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ janik ];
    mainProgram = "alice-lg";
  };
}
