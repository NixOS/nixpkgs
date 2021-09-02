{ lib
, stdenv
, rustPlatform
, buildRustCrate
, defaultCrateOverrides
, fetchFromGitHub
, Security
, libiconv
, pkg-config
, zlib
, features ? [ ]
}:

let
  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "MeiliSearch";
    rev = "v0.21.1";
    sha256 = "sha256-wyyhTNhVw8EJhahstLK+QuEhufQC68rMpw/ngK8FL8Y=";
  };
  custom = pkgs: buildRustCrate.override {
    defaultCrateOverrides = defaultCrateOverrides // {
      meilisearch-http = attrs: {
        src = "${src}/meilisearch-http";
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];
      };
      meilisearch-error = attrs: {
        src = "${src}/meilisearch-error";
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      bitflags = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      const_fn = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      encoding_rs = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      futures-core = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      futures-task = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      httparse = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      indexmap = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      libc = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      log = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      memchr = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      paste = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      futures-util = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      proc-macro-hack = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      serde = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      tokio = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      typenum = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      proc-macro2 = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      generic-array = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      ahash = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      standback = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      syn = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      anyhow = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      crc32fast = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      crossbeam-utils = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      futures-channel = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      fst = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      getrandom = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      hashbrown = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      memoffset = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      miniz_oxide = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      crossbeam-epoch = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      num-traits = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      num-integer = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      proc-macro-error-attr = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      proc-macro-nested = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      rayon-core = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      rayon = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      brotli-sys = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      lmdb-rkv-sys = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      libz-sys = attrs: {
        nativeBuildInputs = [ pkg-config ];
        buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ libiconv ];
        extraLinkFlags = [ "-L${zlib.out}/lib" ];
      };
      rustversion = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      ryu = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      snap = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      ring = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      jieba-rs = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      logging_timer_proc_macros = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      zstd-sys = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      zstd-safe = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      async-trait = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      actix-macros = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      actix-web-codegen = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      concat-arrays = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      async-stream-impl = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      enum-iterator-derive = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      futures-macro = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      proc-macro-error = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      pest_derive = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      serde_derive = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      getset = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      pin-project-internal = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      structopt-derive = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      derive_more = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      thiserror-impl = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      time-macros-impl = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      tokio-macros = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      time = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      zerocopy-derive = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      cookie = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      serde_json = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
      vergen = attrs: {
        buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];
      };
    };
  };
  cargo_nix = import ./Cargo.nix {
    buildRustCrateForPkgs = custom;
  };
in
cargo_nix.workspaceMembers."meilisearch-http".build.override {
  inherit features;
}
