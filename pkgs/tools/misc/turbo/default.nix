{ stdenv
, lib
, fetchFromGitHub
, buildGo120Module
, git
, nodejs
, capnproto
, protobuf
, protoc-gen-go
, protoc-gen-go-grpc
, rustPlatform
, pkg-config
, openssl
, extra-cmake-modules
, fontconfig
, rust-jemalloc-sys
, testers
, turbo
, nix-update-script
, go
, zlib
, libiconv
, Security
, IOKit
, CoreServices
, CoreFoundation
}:
let
  version = "1.11.3";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    hash = "sha256-hjJXbGct9ZmriKdVjB7gwfmFsV1Tv57V7DfUMFZ8Xv0=";
  };

  ffi = rustPlatform.buildRustPackage {
    pname = "turbo-ffi";
    inherit src version;
    cargoBuildFlags = [ "--package" "turborepo-ffi" ];

    cargoHash = "sha256-3eN8/nBARuaezlzPjAL0YPEPvNqm6jNQAREth8PgcSQ=";

    RUSTC_BOOTSTRAP = 1;
    nativeBuildInputs = [
      pkg-config
      extra-cmake-modules
      protobuf
    ];
    buildInputs = [
      openssl
      fontconfig
    ];

    doCheck = false;

    postInstall = ''
      cp target/release-tmp/libturborepo_ffi.a $out/lib
    '';
  };


  go-turbo = buildGo120Module {
    inherit src version;
    pname = "go-turbo";
    modRoot = "cli";

    proxyVendor = true;
    vendorHash = "sha256-JHTg9Gcc0DVdltTGCUaOPSVxL0XVkwPJQm/LoKffU/o=";

    nativeBuildInputs = [
      git
      nodejs
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
    ];

    buildInputs = [zlib ] ++ lib.optionals stdenv.isDarwin [
      Security
      libiconv
    ];

    ldflags = [
      "-s -w"
      "-X main.version=${version}"
      "-X main.commit=${src.rev}"
      "-X main.date=1970-01-01-00:00:01"
      "-X main.builtBy=goreleaser"
    ];

    preBuild = ''
      make compile-protos
      cp ${ffi}/lib/libturborepo_ffi.a ./internal/ffi/libturborepo_ffi_${go.GOOS}_${go.GOARCH}.a
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

      # package_deps_hash_test.go:492: hash of child-dir/libA/pkgignorethisdir/file, got 67aed78ea231bdee3de45b6d47d8f32a0a792f6d want go-turbo>     package_deps_hash_test.go:499: found extra hashes in map[.gitignore:3237694bc3312ded18386964 a855074af7b066af some-dir/another-one:7e59c6a6ea9098c6d3beb00e753e2c54ea502311 some-dir/excluded-file:7e59 c6a6ea9098c6d3beb00e753e2c54ea502311 some-dir/other-file:7e59c6a6ea9098c6d3beb00e753e2c54ea502311 some-fil e:7e59c6a6ea9098c6d3beb00e753e2c54ea502311]
      rm ./internal/hashing/package_deps_hash_test.go
      rm ./internal/hashing/package_deps_hash_go_test.go
      #  Error:          Not equal:
      # expected: env.DetailedMap{All:env.EnvironmentVariableMap(nil), BySource:env.BySource{Explicit:env.EnvironmentVariableMap{}, Matching:env.EnvironmentVariableMap{}}}
      #  actual  : env.DetailedMap{All:env.EnvironmentVariableMap{}, BySource:env.BySource{Explicit:env.EnvironmentVariableMap{}, Matching:env.EnvironmentVariableMap{}}}
      rm ./internal/run/global_hash_test.go
    '';

  };
in
rustPlatform.buildRustPackage {
  pname = "turbo";
  inherit src version;
  cargoBuildFlags = [
    "--package"
    "turbo"
  ];
  RELEASE_TURBO_CLI = "true";

  cargoHash = "sha256-bAXO4Lqv4ibo+fz3679MjNgP2MMY8TbxhG0+DRy0xcA=";

  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    extra-cmake-modules
    protobuf
    capnproto
  ];
  buildInputs = [
    openssl
    fontconfig
    rust-jemalloc-sys
  ] ++ lib.optionals stdenv.isDarwin [
      IOKit
      CoreServices
      CoreFoundation
  ];

  postInstall = ''
    ln -s ${go-turbo}/bin/turbo $out/bin/go-turbo
  '';

  # Browser tests time out with chromium and google-chrome
  doCheck = false;

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex" "^\d+\.\d+\.\d+$" ];
    };
    tests.version = testers.testVersion { package = turbo; };
  };

  meta = with lib; {
    description = "High-performance build system for JavaScript and TypeScript codebases";
    homepage = "https://turbo.build/";
    maintainers = with maintainers; [ dlip ];
    license = licenses.mpl20;
  };
}
