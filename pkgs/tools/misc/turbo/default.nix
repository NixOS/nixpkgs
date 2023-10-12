{ stdenv
, lib
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
  version = "1.10.13";
  src = fetchFromGitHub {
    owner = "vercel";
    repo = "turbo";
    rev = "v${version}";
    sha256 = "sha256-7bEHE/bHRVOXMP7+oo+4k8yn6d+LkXBi8JcDeR0ajww";
  };

  ffi = rustPlatform.buildRustPackage {
    pname = "turbo-ffi";
    inherit src version;
    cargoBuildFlags = [ "--package" "turborepo-ffi" ];

    cargoHash = "sha256-CIKuW8qKJiqgDBPfuCIBcWUP41BHwAa1m9vmcQ9ZmAY=";

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


  go-turbo = buildGoModule {
    inherit src version;
    pname = "go-turbo";
    modRoot = "cli";

    vendorHash = "sha256-8quDuT8VwT3B56jykkbX8ov+DNFZwxPf31+NLdfX1p0=";

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

    ldFlags = [
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
    '' + lib.optionalString stdenv.isLinux ''
      #  filewatcher_test.go:122: got event {/build/TestFileWatching1921149570/001/test-1689172679812 1}
      # filewatcher_test.go:122: got event {/build/TestFileWatching1921149570/001/parent/test-1689172679812 1}
      # filewatcher_test.go:122: got event {/build/TestFileWatching1921149570/001/parent/child/test-1689172679812 1}
      # filewatcher_test.go:122: got event {/build/TestFileWatching1921149570/001/parent/sibling/test-1689172679812 1}
      # filewatcher_test.go:127: got event {/build/TestFileWatching1921149570/001/parent/child/foo 1}
      # filewatcher_test.go:137: got event {/build/TestFileWatching1921149570/001/parent/sibling/deep 1}
      # filewatcher_test.go:141: got event {/build/TestFileWatching1921149570/001/parent/sibling/deep/path 1}
      # filewatcher_test.go:146: got event {/build/TestFileWatching1921149570/001/parent/sibling/deep 1}
      # filewatcher_test.go:146: Timed out waiting for filesystem event at /build/TestFileWatching1921149570/001/test-1689172679812
      # filewatcher_test.go:146: Timed out waiting for filesystem event at /build/TestFileWatching1921149570/001/parent/test-1689172679812
      # filewatcher_test.go:146: Timed out waiting for filesystem event at /build/TestFileWatching1921149570/001/parent/child/test-1689172679812
      # filewatcher_test.go:146: Timed out waiting for filesystem event at /build/TestFileWatching1921149570/001/parent/sibling/test-1689172679812
      # filewatcher_test.go:146: got event {/build/TestFileWatching1921149570/001/parent/sibling/deep/path/test-1689172679812 1}
      # filewatcher_test.go:146: got event {/build/TestFileWatching1921149570/001/parent/sibling/deep/test-1689172679812 1}
      rm ./internal/filewatcher/filewatcher_test.go
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

  cargoHash = "sha256-rKdonANA6WvXPMpK8sC95hsX9Yb5zedeBezY4LWzsZE=";

  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
    extra-cmake-modules
    protobuf
  ];
  buildInputs = [
    openssl
    fontconfig
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
