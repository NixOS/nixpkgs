{
  callPackage, fetchFromGitHub, buildGoModule, stdenv,
  go-bindata, git
}:

let
  yarn2nix = (callPackage (fetchFromGitHub {
    owner  = "moretea";
    repo   = "yarn2nix";
    rev    = "3cc020e384ce2a439813adb7a0cc772a034d90bb";
    sha256 = "0h2kzdfiw43rbiiffpqq9lkhvdv8mgzz2w29pzrxgv8d39x67vr9";
  }) {});

  version = "1.7.11";

  src = (fetchFromGitHub {
    owner = "influxdata";
    repo = "chronograf";
    rev = version;
    sha256 = "0ymxm87a6xq01xkimhw6xwgl6wpvsfgyz2r3hric2y8rkqi8bbmk";
  });

  ui = yarn2nix.mkYarnPackage {
    name = "chronograf-ui-${version}";
    inherit version;

    src = "${src}/ui";

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;

    extraBuildInputs = [ git ];

    buildPhase = ''
      cd deps/chronograf-ui
      yarn run build
      mkdir -p $out
      cp ./build/* $out
    '';

    installPhase = '':'';

    distPhase = '':'';
  };
in

buildGoModule rec {
  name = "chronograf-${version}";

  inherit src;

  modSha256 = "0c8inpcf1p3h1mp7xwhywvh9j4ws68hm9010w85psc78r1z1na2d";

  subPackages = [
    "cmd/chronoctl"
    "cmd/chronograf"
  ];

  buildInputs = [ go-bindata ];

  preBuild = ''
    cp -R ${ui} ui/build
    go generate -x ./server
    go generate -x ./canned
    go generate -x ./protoboards
    go generate -x ./dist
  '';

  buildFlagsArray = [ ''-ldflags=
    -s
    -X main.version=${version}
  '' ];

  meta = with stdenv.lib; {
    description = "Open source monitoring and visualization UI for the TICK stack";
    longDescription = ''
      Chronograf is an open-source web application written in Go and React.js that
      provides the tools to visualize your monitoring data and easily create alerting
      and automation rules.
    '';
    homepage = "https://github.com/influxdata/chronograf";
    license = licenses.agpl3;
    maintainers = [ maintainers.nefix ];
    platforms = platforms.all;
  };
}

