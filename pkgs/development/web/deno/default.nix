{ stdenv
, fetchurl
, fetchFromGitHub
, rust
, rustPlatform
, installShellFiles
, Security
, CoreServices
}:
let
  deps = import ./deps.nix { };
  arch = rust.toRustTarget stdenv.hostPlatform;
  rustyV8Lib = with deps.rustyV8Lib; fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v${version}/librusty_v8_release_${arch}.a";
    sha256 = sha256s."${stdenv.hostPlatform.system}";
    meta = { inherit version; };
  };
in
rustPlatform.buildRustPackage rec {
  pname = "deno";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    sha256 = "19ki9qyg9q26jq4jkcf8b6xhy4g4cn30zqccgl3324mnijhl33jk";
    fetchSubmodules = true;
  };
  cargoSha256 = "1q3gmilphkbh54y7m711ccr1gr5slk2nn91qq61rmmphyylwkgv2";

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security CoreServices ];

  # The rusty_v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and place it in the locations it will require it in advance
  preBuild = ''
    _rusty_v8_setup() {
      for v in "$@"; do
        dir="target/$v/gn_out/obj"
        mkdir -p "$dir" && cp "${rustyV8Lib}" "$dir/librusty_v8.a"
      done
    }

    # Copy over the `librusty_v8.a` file inside target/XYZ/gn_out/obj, symlink not allowed
    _rusty_v8_setup "debug" "release" "${arch}/release"
  '';

  # Tests have some inconsistencies between runs with output integration tests
  # Skipping until resolved
  doCheck = false;

  # TODO: Move to enhanced installShellCompletion when merged: PR #83630
  postInstall = ''
    # remove test plugin and test server
    rm -rf $out/lib $out/bin/test_server

    $out/bin/deno completions bash > deno.bash
    $out/bin/deno completions fish > deno.fish
    $out/bin/deno completions zsh  > _deno
    installShellCompletion deno.{bash,fish} --zsh _deno
  '';

  passthru.updateScript = ./update/update.ts;

  meta = with stdenv.lib; {
    homepage = "https://deno.land/";
    changelog = "${src.meta.homepage}/releases/tag/v${version}";
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
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
