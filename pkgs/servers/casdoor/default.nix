{ lib
, buildGoModule
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, makeWrapper
, substituteAll
}:

let

  pname = "casdoor";
  version = "1.379.0";

  fullSrc = fetchFromGitHub {
    owner = "casdoor";
    repo = "casdoor";
    rev = "v${version}";
    hash = "sha256-V+8i98n3tK0Ni5nuh0mRN2ojURIbbzVJCrdcBrB+QuQ=";
  };

  web-build = mkYarnPackage rec {
    inherit version;
    src = fullSrc + "/web";

    pname = "casdoor-web";

    offlineCache = fetchYarnDeps {
      yarnLock = src + "/yarn.lock";
      sha256 = "sha256-YVLsn5vX7Azg0QxQPpvknciHwzkp3CUDcifLfqoe860=";
    };

    packageJSON = ./package.json;

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)

      DISABLE_ESLINT_PLUGIN=true yarn --offline build

      mkdir -p $out/share/web

      cp -r deps/web/build $out/share/web

      runHook postBuild
    '';

    distPhase = "true";
    dontInstall = true;
  };
in
buildGoModule {

  inherit pname version;
  src = fullSrc;

  vendorHash = "sha256-1qHUUX3F0OOMQVHDwJTG1nvk5J0/KgJTh5YIYkONPBc=";

  doCheck = false; # requires network access

  ldflags = [ "-s" "-w" ];

  patches = [
    # The webroot is hardcoded as ./wwwroot
    (substituteAll {
      src = ./fix-webroot.patch;
      web_root = "${web-build}/share/";
    })
  ];

  meta = with lib; {
    description =
      "An open-source Identity and Access Management (IAM) / Single-Sign-On (SSO) platform";
    homepage = "https://github.com/casdoor/casdoor";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
