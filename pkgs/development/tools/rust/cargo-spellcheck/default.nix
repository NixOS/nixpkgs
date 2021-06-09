{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, pkg-config
, hunspell
, hunspellDicts
, llvmPackages
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lf7xy34vc38bn2m7nzn9hjl2q7wyimjp53d4k7nq88q2zv3ls7h";
  };

  cargoSha256 = "1f2vl8fk6wflq6bbz4sis29q0rri83xxwkbw519i2x02lqy9paa0";

  cargoPatches = [ ./use-system-hunspell.patch ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  # We need to point where the lib and headers are located otherwise
  # hunspell-sys fail to build.
  preConfigure = ''
    export BINDGEN_EXTRA_CLANG_ARGS="$(pkg-config --libs --cflags hunspell) $NIX_CFLAGS_COMPILE"
  '';

  # We use bindgen and it requires the libclang to properly run.
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  buildInputs = [ hunspell llvmPackages.libclang ];

  nativeBuildInputs = [ pkg-config ];

  checkInputs = [ hunspellDicts.en-us ];

  meta = with lib; {
    description = ''Cargo subcommand "spellcheck": checks all doc comments for spelling mistakes'';
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    license = with licenses; [
      # we use default build features which includes nlprules so LGPL-2.1
      lgpl21Only
    ];
    maintainers = with maintainers; [ otavio ];
  };
}
