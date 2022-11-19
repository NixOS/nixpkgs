{ stdenv, lib, makeWrapper, swiProlog, fetchFromGitHub, rustPlatform, m4, fetchzip, libjwt,cmake, pkg-config, breakpointHook }:

let
  TUS_VERSION = "0.0.10";
  JWT_VERSION = "0.0.5";
  DASHBOARD_VERSION = "0.0.10";

  tus = fetchFromGitHub {
    owner = "terminusdb";
    repo = "tus";
    rev = "v${TUS_VERSION}";
    sha256 = "sha256-kgYDMcItdh9i3EQYOH5oxvAIUF+IoHB8tUVmCnJckS4=";
  };

  dashboard = fetchzip {
    url = "https://github.com/terminusdb/terminusdb-dashboard/releases/download/v${DASHBOARD_VERSION}/release.tar.gz";
    sha256 = "sha256-NyUgURa9Bg8/wMoZiVu901ERgY6PW3peGMcBAhMkVc8=";
    stripRoot = false;
  };

  # this one is borked
  #jwt_io = fetchFromGitHub {
  #  owner = "terminusdb-labs";
  #  repo = "jwt_io";
  #  rev = "v${JWT_VERSION}";
  #  sha256 = "sha256-d9TlellJ0wwu9zsxbCjA8tdRQqqKKHGfNV+Yqu3kaCU=";
  #};

  swiProlog_withlibs = (swiProlog.overrideAttrs (finalAttrs: previousAttrs: {
    PKG_CONFIG_PATH = "${libjwt}/lib/pkgconfig/";
    buildInputs = previousAttrs.buildInputs ++ [libjwt];
  })).override {
    extraPacks = map (dep-path: "'file://${dep-path}'") [
      tus
      #jwt_io
    ];
  };
in
stdenv.mkDerivation rec {
  pname = "terminusdb";
  version = "10.1.8";

  src = fetchFromGitHub {
    repo = "terminusdb";
    owner = "terminusdb";
    rev = "v${version}";
    sha256 = "sha256-Rga3WCaUIvGjHfgLoQ0KVBvSAACAnQNttkVlyr+ecGY=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/src/rust/Cargo.lock";
  };
  cargoRoot = "src/rust";

  buildInputs = [
    makeWrapper
    (with rustPlatform; [
      cargoSetupHook
      rust.cargo
      rust.rustc
      rust.rustc.llvmPackages.clang
    ])
    m4
    swiProlog_withlibs
    libjwt
    pkg-config
  ];

  patches = [ ./dashboard.patch ];

  inherit dashboard;

  TERMINUSDB_DASHBOARD_DIR = "${placeholder "out"}/dashboard";
  LIBCLANG_PATH = lib.makeLibraryPath [ rustPlatform.rust.rustc.llvmPackages.libclang.lib ];

  installPhase = ''
    mkdir -p $out/bin
    cp terminusdb $out/bin/
    cp ${dashboard} -r $out/dashboard
  '';
  dontStrip = true;

  meta = with lib; {
    description = "A git-like open-source document graph database.";
    homepage = "https://terminusdb.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ blueforesticarus ];
  };
}
