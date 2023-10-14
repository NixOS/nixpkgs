{ lib
, fetchFromGitHub
, mkYarnPackage
, buildGoModule
, makeWrapper
, v2ray
, v2ray-geoip
, v2ray-domain-list-community
, symlinkJoin
, fetchYarnDeps
}:
let
  pname = "v2raya";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "v${version}";
    hash = "sha256-oMH4FutgI5mLz2sxDdPFUyDd80xT32r51HEQYhhnvcU=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/gui/yarn.lock";
  };
  guiSrc = "${src}/gui";

  web = mkYarnPackage {
    inherit pname version;

    src = guiSrc;
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${guiSrc}/yarn.lock";
      sha256 = "sha256-hVtETKhG9kX/4a4uO/aQ9sN2eTF6aAYaKDSHJIa0eWQ=";
    };

    buildPhase = ''
      export NODE_OPTIONS=--openssl-legacy-provider
      OUTPUT_DIR=$out yarn --offline build
    '';

    configurePhase = ''
      cp -r $node_modules node_modules
      chmod +w node_modules
    '';

    distPhase = "true";

    dontInstall = true;
    dontFixup = true;
  };

  assetsDir = symlinkJoin {
    name = "assets";
    paths = [ v2ray-geoip v2ray-domain-list-community ];
  };

in
buildGoModule {
  inherit pname version;

  src = "${src}/service";
  vendorHash = "sha256-nI+nqftJybAGcHCTMVjYPuLHxqE/kyjUzkspnkzUi+g=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/v2rayA/v2rayA/conf.Version=${version}"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper ];
  preBuild = ''
    cp -a ${web} server/router/web
  '';

  postInstall = ''
    install -Dm 444 ${src}/install/universal/v2raya.desktop -t $out/share/applications
    install -Dm 444 ${src}/install/universal/v2raya.png -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/v2raya.desktop \
      --replace 'Icon=/usr/share/icons/hicolor/512x512/apps/v2raya.png' 'Icon=v2raya'

    wrapProgram $out/bin/v2rayA \
      --prefix PATH ":" "${lib.makeBinPath [ v2ray ]}" \
      --prefix XDG_DATA_DIRS ":" ${assetsDir}/share
  '';

  meta = with lib; {
    description = "A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    mainProgram = "v2rayA";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elliot ];
  };
}
