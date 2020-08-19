{ buildGoModule, mkYarnPackage, fetchFromGitHub, lib, tree }:

let
  version = "0.90.63";

  src = fetchFromGitHub {
    owner = "statping";
    repo = "statping";
    rev = "v${version}";
    sha256 = "01cvl7xg8xfdqn5yvnllcg7ippdch9yi60vnvhlxam4dpfqvc1xi";
  };

  frontend = mkYarnPackage {
    name = "statping-frontend";
    src = "${src}/frontend";
    packageJSON = "${src}/frontend/package.json";
    yarnLock = "${src}/frontend/yarn.lock";
    #yarnNix = ./yarndeps.nix;
  };
in buildGoModule rec {
  pname = "statping";
  inherit src version;

  vendorSha256 = "1p45ld6r0iy7gbxbpwis78ygqi0h8cslgb4xcskygkc4aq9ksxr3";

  postPatch = ''
${tree}/bin/tree -L 4 ${frontend}
echo XXXXXXXXXXXXXXXXXXXX
    cp -r ${frontend}/libexec/statping/deps/statping source/dist
    ls -la source/dist
    cp -r ${src}/frontend/src/assets/scss source/dist/
    cp ${src}/frontend/public/favicon.ico source/dist/
    cp ${src}/frontend/public/robots.txt source/dist/
    cp ${src}/frontend/public/banner.png source/dist/
    cp -r ${src}/frontend/public/favicon source/dist/
  '';

  subPackages = [ "cmd" ];

  # has no effect. binary still named cmd and `cmd version` empty
  buildFlagsArray = [
  "-tags=netgo"
  "-o statping"
  ''
    -ldflags='-X main.VERSION=${version} -X main.COMMIT=${version}'
  ''
  ];

  meta = with lib; {
    description = "An open source server to monitor your web applications and all other HTTP, TCP, UDP and gRPC services";
    homepage = "https://statping.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ davidak ];
    platforms = with platforms; linux ++ darwin;
  };
}
