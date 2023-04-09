{ stdenv
, lib
, callPackage
, fetchFromGitHub
, fetchpatch
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
  version = "1.31.1";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0S5BSXWnv4DMcc8cijRQx6NyDReg5aJJT65TeNFlkkw=";
  };
  cargoHash = "sha256-7Xfnc91yQiAwAF5fvtiwnELUDb7LJeye3GtXNzYkUo8=";

  cargoPatches = [
    # resolved in 1.31.2
    (fetchpatch {
      name = "CVE-2023-28446.patch";
      url = "https://github.com/denoland/deno/commit/78d430103a8f6931154ddbbe19d36f3b8630286d.patch";
      hash = "sha256-kXwr9wWxk1OaaubCr8pfmSp3TrJMQkbAg72nIHp/seA=";
    })
  ];

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
    maintainers = with maintainers; [ jk ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
