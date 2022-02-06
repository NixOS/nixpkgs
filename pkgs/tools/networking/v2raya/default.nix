{ lib
, fetchFromGitHub
, mkYarnPackage
, buildGoModule
, makeWrapper
, v2ray
, v2ray-geoip
, v2ray-domain-list-community
, symlinkJoin
}:
let
  pname = "v2raya";
  version = "unstable-2022-02-06";
  git-rev = "da65d2b4d7c9b2c1646583c02b4e90e4ab15c511";
  src = fetchFromGitHub {
    owner = "v2rayA";
    repo = "v2rayA";
    rev = git-rev;
    sha256 = "sha256-Hj7GDuz27OJrMz1JfkyS01dakK5ddV6MxIMh+GrYwNg=";
  };
  web = mkYarnPackage {
    inherit pname version;
    src = "${src}/gui";
    yarnNix = ./yarn.nix;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    buildPhase = ''
      ln -s $src/postcss.config.js postcss.config.js
      OUTPUT_DIR=$out yarn --offline build
    '';
    distPhase = "true";
    dontInstall = true;
    dontFixup = true;
  };
in
buildGoModule {
  inherit pname version;
  src = "${src}/service";
  vendorSha256 = "sha256-E3UAOaUo28Bztmsy1URr6VNAT7Ice3Gqlh47rnLcHWg=";
  subPackages = [ "." ];
  nativeBuildInputs = [ makeWrapper ];
  preBuild = ''
    cp -a ${web} server/router/web
  '';
  postInstall = ''
    wrapProgram $out/bin/v2rayA \
      --prefix PATH ":" "${lib.makeBinPath [ v2ray.core ]}" \
      --prefix XDG_DATA_DIRS ":" ${symlinkJoin {
        name = "assets";
        paths = [ v2ray-geoip v2ray-domain-list-community ];
      }}/share
  '';
  meta = with lib; {
    description = "A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel";
    homepage = "https://github.com/v2rayA/v2rayA";
    mainProgram = "v2rayA";
    license = licenses.agpl3Only;
    maintainers = with lib.maintainers; [ shanoaice ];
  };
}
