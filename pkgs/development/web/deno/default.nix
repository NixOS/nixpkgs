{ stdenv
, lib
, callPackage
, fetchFromGitHub
, rust
, rustPlatform
, installShellFiles
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
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IFEo2F3gayR2LmAAJXezZPXpRfZf4re3YPZRcXpqx6o=";
  };
  cargoSha256 = "sha256-9ZpPiqlqP01B9ETpVqVreivNuSMB1td4LinxXdH7PsM=";

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  buildAndTestSubdir = "cli";

  buildInputs = lib.optionals stdenv.isDarwin
    [ libiconv libobjc Security CoreServices Metal Foundation QuartzCore ];

  # The rusty_v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and place it in the locations it will require it in advance
  preBuild =
    let arch = rust.toRustTarget stdenv.hostPlatform; in
    ''
      _librusty_v8_setup() {
        for v in "$@"; do
          install -D ${librusty_v8} "target/$v/gn_out/obj/librusty_v8.a"
        done
      }

      # Copy over the `librusty_v8.a` file inside target/XYZ/gn_out/obj, symlink not allowed
      _librusty_v8_setup "debug" "release" "${arch}/release"
    '';

  # Tests have some inconsistencies between runs with output integration tests
  # Skipping until resolved
  doCheck = false;

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
