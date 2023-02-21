{ lib
, fetchFromGitHub
, buildGoModule
, git
, nodejs
, protobuf
, protoc-gen-go
, protoc-gen-go-grpc
, rustPlatform
, pkg-config
, openssl
, extra-cmake-modules
, fontconfig
, go
}:
let
  version = "1.8.1";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-CkGi7qtFcioQAHeqKkHGrI/iMu8MnlK7IVmCB4AqIfo=";
  };

  go-turbo = buildGoModule rec {
    inherit src version;
    pname = "go-turbo";
    modRoot = "cli";

    vendorSha256 = "sha256-lqumN+xqJXEPI+nVnWSNfAyvQQ6fS9ao8uhwA1EbWWM=";

    nativeBuildInputs = [
      git
      nodejs
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];

    preBuild = ''
      make compile-protos
    '';

    preCheck = ''
      # Some tests try to run mkdir $HOME
      HOME=$TMP

      # Test_getTraversePath requires that source is a git repo
      # pwd: /build/source/cli
      pushd ..
      git config --global init.defaultBranch main
      git init
      popd
    '';

  };
in
rustPlatform.buildRustPackage rec {
  pname = "turbo";
  inherit src version;
  cargoBuildFlags = [
    "--package"
    "turbo"
  ];
  RELEASE_TURBO_CLI = "true";

  cargoSha256 = "sha256-swq8cOAM0AOvFtyHLyJgi/ngZ8vxGxylINMFzJH/Pd8=";
  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    extra-cmake-modules
  ];
  buildInputs = [
    openssl
    fontconfig
  ];

  postInstall = ''
    ln -s ${go-turbo}/bin/turbo $out/bin/go-turbo
  '';

  # Browser tests time out with chromium and google-chrome
  doCheck = false;

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
