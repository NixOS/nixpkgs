{ stdenv
, lib
, callPackage
, fetchFromGitHub
, rustPlatform
, cmake
, protobuf
, installShellFiles
, libiconv
, darwin
, librusty_v8 ? callPackage ./librusty_v8.nix { }
}:

rustPlatform.buildRustPackage rec {
  pname = "deno";
  version = "1.40.2";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ycQN4BKuvK4FRYbHUKFFMVFg0LAG64xFiXbAkmQ46Cs=";
  };

  cargoHash = "sha256-5OnYtVsuf6q4nQGO1+qL+2WFaKW0k13fNFS29gKaWhk=";

  postPatch = ''
    # upstream uses lld on aarch64-darwin for faster builds
    # within nix lld looks for CoreFoundation rather than CoreFoundation.tbd and fails
    substituteInPlace .cargo/config.toml --replace "-fuse-ld=lld " ""
  '';

  # uses zlib-ng but can't dynamically link yet
  # https://github.com/rust-lang/libz-sys/issues/158
  nativeBuildInputs = [
    # required by libz-ng-sys crate
    cmake
    # required by deno_kv crate
    protobuf
    installShellFiles
  ];
  buildInputs = lib.optionals stdenv.isDarwin (
    [ libiconv darwin.libobjc ] ++
    (with darwin.apple_sdk_11_0.frameworks; [
      Security
      CoreServices
      Metal
      MetalPerformanceShaders
      Foundation
      QuartzCore
    ])
  );

  # work around "error: unknown warning group '-Wunused-but-set-parameter'"
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-unknown-warning-option";

  buildAndTestSubdir = "cli";

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = librusty_v8;

  # Tests have some inconsistencies between runs with output integration tests
  # Skipping until resolved
  doCheck = false;

  preInstall = ''
    find ./target -name libswc_common${stdenv.hostPlatform.extensions.sharedLibrary} -delete
  '';

  postInstall = ''
    installShellCompletion --cmd deno \
      --bash <($out/bin/deno completions bash) \
      --fish <($out/bin/deno completions fish) \
      --zsh <($out/bin/deno completions zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/deno --help
    $out/bin/deno --version | grep "deno ${version}"
    runHook postInstallCheck
  '';

  passthru.updateScript = ./update/update.ts;
  passthru.tests = callPackage ./tests { };

  meta = with lib; {
    homepage = "https://deno.land/";
    changelog = "https://github.com/denoland/deno/releases/tag/v${version}";
    description = "A secure runtime for JavaScript and TypeScript";
    longDescription = ''
      Deno aims to be a productive and secure scripting environment for the modern programmer.
      Deno will always be distributed as a single executable.
      Given a URL to a Deno program, it is runnable with nothing more than the ~15 megabyte zipped executable.
      Deno explicitly takes on the role of both runtime and package manager.
      It uses a standard browser-compatible protocol for loading modules: URLs.
      Among other things, Deno is a great replacement for utility scripts that may have been historically written with
      bash or python.
    '';
    license = licenses.mit;
    mainProgram = "deno";
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
