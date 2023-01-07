{ stdenv
, lib
, callPackage
, fetchFromGitHub
, rustPlatform
, installShellFiles
, tinycc
, libiconv
, libobjc
, Security
, CoreServices
, Metal
, Foundation
, QuartzCore
, librusty_v8 ? callPackage ./librusty_v8.nix { }
}:

rustPlatform.buildRustPackage rec {
  pname = "deno";
  version = "1.29.2";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZWM8VZifgVvCpjdOXKLHpN8jgFFqi5S9BklV5R2M9BU=";
  };
  cargoSha256 = "sha256-qlNCbLeDoZ+oweEKIZf66Tq+62mKodliXHp9QtC+b58=";

  postPatch = ''
    # upstream uses lld on aarch64-darwin for faster builds
    # within nix lld looks for CoreFoundation rather than CoreFoundation.tbd and fails
    substituteInPlace .cargo/config.toml --replace '"-C", "link-arg=-fuse-ld=lld"' ""
  '';

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin
    [ libiconv libobjc Security CoreServices Metal Foundation QuartzCore ];

  buildAndTestSubdir = "cli";

  # The v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and export it via RUSTY_V8_ARCHIVE
  RUSTY_V8_ARCHIVE = librusty_v8;

  # The deno_ffi package currently needs libtcc.a on linux and macos and will try to compile it at build time
  # To avoid this we point it to our copy (dir)
  # In the future tinycc will be replaced with asm
  libtcc = tinycc.overrideAttrs (oa: {
    makeFlags = [ "libtcc.a" ];
    # tests want tcc binary
    doCheck = false;
    outputs = [ "out" ];
    installPhase = ''
      mkdir -p $out/lib/
      mv libtcc.a $out/lib/
    '';
    # building the whole of tcc on darwin is broken in nixpkgs
    # but just building libtcc.a works fine so mark this as unbroken
    meta.broken = false;
  });
  TCC_PATH = "${libtcc}/lib";

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
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
