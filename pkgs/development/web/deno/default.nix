{ stdenv
, fetchurl
, fetchFromGitHub
, rust
, rustPlatform
, python27
, installShellFiles
, Security
, CoreServices
}:
let
  pname = "deno";
  version = "1.0.0";

  denoSrc = fetchFromGitHub {
    owner = "denoland";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k8mqy1hf9hkp60jhd0x4z814y36g51083b3r7prc69ih2523hd1";

    fetchSubmodules = true;
  };
  cargoSha256 = "1fjl07qqvl1f20qazcqxh32xmdfh80jni7i3jzvz6vgsfw1g5cmk";

  rustyV8Lib = fetchlib "rusty_v8" "0.4.2" {
    x86_64-linux = "1ac6kv3kv087df6kdgfd7kbh24187cg9z7xhbz6rw6jjv4ci2zbi";
    aarch64-linux = "06iyjx4p4vp2i81wdy0vxai2k18pki972ff7k0scjqrgmnav1p8k";
    x86_64-darwin = "02hwbpsqdzb9mvfndgykvv44f1jig3w3a26l0h26hs5shsrp47jv";
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

  nativeBuildInputs = [
    # chromium/V8 requires python 2.7, we're not building V8 from source
    # but as a result rusty_v8's download script also uses python 2.7
    # tracking issue: https://bugs.chromium.org/p/chromium/issues/detail?id=942720
    python27

    # Install completions post-install
    installShellFiles
  ];

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

  # Set home to existing env var TMP dir so tests that write there work correctly
  preCheck = ''
    export HOME="$TMPDIR"
  '';

  checkFlags = [
    # Strace not allowed on hydra
    "--skip benchmark_test"

    # Tests that try to write to `/build/source/target/debug`
    "--skip _017_import_redirect"
    "--skip https_import"
    "--skip js_unit_tests"
    "--skip lock_write_fetch"

    # Cargo test runs a deno test on the std lib with sub-benchmarking-tests,
    # The sub-sub-tests that are failing:
    # forAwaitFetchDenolandX10, promiseAllFetchDenolandX10is
    # Trying to access https://deno.land/ on build's limited network access
    "--skip std_tests"

    # Fails on aarch64 machines
    # tracking issue: https://github.com/denoland/deno/issues/5324
    "--skip run_v8_flags"

    # Skip for multiple reasons:
    # downloads x86_64 binary on aarch64 machines
    # tracking issue: https://github.com/denoland/deno/pull/5402
    # downloads a binary that needs ELF patching & tries to run imediately
    # upgrade will likely never work with nix as it tries to replace itself
    # code: https://github.com/denoland/deno/blob/v1.0.0/cli/upgrade.rs#L211
    "--skip upgrade_in_tmpdir"
    "--skip upgrade_with_version_in_tmpdir"
  ];

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
