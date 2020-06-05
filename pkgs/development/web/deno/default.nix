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
  rustyV8Lib = fetchlib "rusty_v8" "0.5.0" {
    x86_64-linux = "1jmrqf5ns2y51cxx9r88my15m6gc6wmg54xadi3kphq47n4hmdfw";
    aarch64-linux = "14v57pxpkz1fs483rbbc8k55rc4x41dqi0k12zdrjwa5ycdam3m5";
    x86_64-darwin = "0466px7k2zvbsswwcrr342i5ml669gf76xd8yzzypsmb7l71s6vr";
  };

  arch = rust.toRustTarget stdenv.hostPlatform;
  fetchlib = name: version: sha256: fetchurl {
    url = "https://github.com/denoland/${name}/releases/download/v${version}/librusty_v8_release_${arch}.a";
    sha256 = sha256."${stdenv.hostPlatform.system}";
    meta = { inherit version; };
  };
in
rustPlatform.buildRustPackage rec {
  inherit pname version cargoSha256;

  src = denoSrc;

  # Install completions post-install
  nativeBuildInputs = [ installShellFiles ];

  buildInputs = with stdenv.lib; [ ]
    ++ optionals stdenv.isDarwin [ Security CoreServices ];

  # The rusty_v8 package will try to download a `librusty_v8.a` release at build time to our read-only filesystem
  # To avoid this we pre-download the file and place it in the locations it will require it in advance
  preBuild = ''
    # Check the rusty_v8 lib downloaded matches the Cargo.lock file
    rusty_v8_ver="$(grep 'name = "rusty_v8"' -A 1 Cargo.lock | grep "version =" | cut -d\" -f2)"
    if [ "${rustyV8Lib.meta.version}" != "$rusty_v8_ver" ]; then
      printf "%s\n" >&2 \
        "version mismatch between 'rusty_v8' in Cargo.lock and downloaded library:" \
        "  wanted: ${rustyV8Lib.meta.version}" \
        "  got:    $rusty_v8_ver"
      exit 1
    fi;

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
    $out/bin/deno completions bash > deno.bash
    $out/bin/deno completions fish > deno.fish
    $out/bin/deno completions zsh  > _deno
    installShellCompletion deno.{bash,fish} --zsh _deno
  '';

  meta = with stdenv.lib; {
    homepage = "https://deno.land/";
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
