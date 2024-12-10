{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  buildGoModule,
  makeWrapper,
  v2ray,
  v2ray-geoip,
  v2ray-domain-list-community,
  symlinkJoin,
  fetchYarnDeps,
}:
let
  pname = "v2raya";
  version = "2.2.5.1";

  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = "v${version}";
    hash = "sha256-aicKjirUHNeCCxfW9aaPI+X5DTQ0RdZnCxIQRU+GdCM=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/gui/yarn.lock";
  };
  guiSrc = "${src}/gui";

  web = mkYarnPackage {
    inherit pname version;

    src = guiSrc;
    packageJSON = ./package.json;

    offlineCache = fetchYarnDeps {
      yarnLock = "${guiSrc}/yarn.lock";
      sha256 = "sha256-AZIYkW2u1l9IaDpR9xiKNpc0sGAarLKwHf5kGnzdpKw=";
    };

    buildPhase = ''
      runHook preBuild
      OUTPUT_DIR=$out yarn --offline build
      runHook postBuild
    '';

    configurePhase = ''
      runHook preConfigure
      cp -r $node_modules node_modules
      chmod +w node_modules
      runHook postConfigure
    '';

    distPhase = "true";

    dontInstall = true;
    dontFixup = true;
  };

  assetsDir = symlinkJoin {
    name = "assets";
    paths = [
      v2ray-geoip
      v2ray-domain-list-community
    ];
  };

in
buildGoModule {
  inherit pname version;

  src = "${src}/service";
  vendorHash = "sha256-/4l13TbE1WEX1xYfyzEwygFsNtT6weoYDll4ejvCyIg=";

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
    maintainers = with maintainers; [ ChaosAttractor ];
  };
}
