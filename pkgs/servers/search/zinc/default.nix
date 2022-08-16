{ lib
, buildGo117Module
, fetchFromGitHub
, mkYarnPackage
}:
let
  pname = "zinc";
  version = "0.2.8";
  fullSrc = fetchFromGitHub {
    owner = "zinclabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nnnrczyfa4pa9i92xwwnzl6p9iphc2wvvbf87y8l760nnda1ar7";
  };
  ui = mkYarnPackage rec {
    name = "${pname}-ui";
    src = "${fullSrc}/web";

    yarnLock = ./yarn.lock;

    buildPhase = ''
      yarn --offline build
      cp -r deps/zinc-search/dist $out
    '';
    dontInstall = true;
    distPhase = "true";
  };
in
buildGo117Module rec {
  inherit version pname;
  src = fullSrc;

  postPatch = ''
    cp -r ${ui} web/dist
  '';

  vendorSha256 = "sha256-kOCGf316bEsyguw24pdSpZTKdCYQxp5Z5qY9dw+zhIM=";
  subPackages = [ "cmd/zinc" ];
  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zinclabs/zinc/pkg/meta.Version=${version}"
  ];

  passthru = {
    updateYarnLockScript = ./update-yarn-lock.sh;
  };

  meta = with lib; {
    description = "A lightweight alternative to elasticsearch that requires minimal resources, written in Go";
    homepage = "https://github.com/zinclabs/zinc";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
