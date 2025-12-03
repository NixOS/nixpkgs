{
  buildPgrxExtension,
  cargo-pgrx_0_16_1,
  fetchFromGitHub,
  fetchurl,
  lib,
  nix-update-script,
  postgresql,
  stdenv,
}:

let
  # https://github.com/paradedb/paradedb/blob/v0.21.0/Cargo.lock#L3305-L3335
  linderaVersion = "1.4.1";
  linderaWebsite = "https://lindera.dev";

  # pg_search's tokenizer uses several language dictionaries used by the Lindera crate
  dictionaries = {
    # https://github.com/lindera/lindera/blob/v1.4.1/lindera-ko-dic/build.rs#L15-L22
    lindera-ko-dic = rec {
      language = "Korean";
      filename = "mecab-ko-dic-2.1.1-20180720.tar.gz";
      source = fetchurl {
        url = "${linderaWebsite}/${filename}";
        hash = "sha256-cCztIcYWfp2a68Z0q17lSvWNREOXXylA030FZ8AgWRo=";
      };
    };

    # https://github.com/lindera/lindera/blob/v1.4.1/lindera-cc-cedict/build.rs#L15-L22
    lindera-cc-cedict = rec {
      language = "Chinese";
      filename = "CC-CEDICT-MeCab-0.1.0-20200409.tar.gz";
      source = fetchurl {
        url = "${linderaWebsite}/${filename}";
        hash = "sha256-7Tz54+yKgGR/DseD3Ana1DuMytLplPXqtv8TpB0JFsg=";
      };
    };

    # https://github.com/lindera/lindera/blob/v1.4.1/lindera-ipadic/build.rs#L15-L22
    lindera-ipadic = rec {
      language = "Japanese";
      filename = "mecab-ipadic-2.7.0-20250920.tar.gz";
      source = fetchurl {
        url = "${linderaWebsite}/${filename}";
        hash = "sha256-p7qfZF/+cJTlauHEqB0QDfj7seKLvheSYi6XKOFi2z0=";
      };
    };
  };
in
buildPgrxExtension (finalAttrs: {
  pname = "pg_search";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "paradedb";
    repo = "paradedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lNroJUXT54zXdYESATEivjAxEP3HfJjdos9VphWa5sQ=";
  };

  cargoHash = "sha256-gNHP6Mv9KrUqYtlqOUBFXdx0xH/JbcF1M1DUARAHCKc=";

  inherit postgresql;

  # Lindera dictionaries are copied to a temporary directory and the
  # LINDERA_CACHE environment variable prevents the build.rs files in
  # the Lindera crates from downloading their dictionary from an
  # external URL, which doesn't work in the Nix sandbox
  preConfigure = ''
    export LINDERA_CACHE=$TMPDIR/lindera-cache
    mkdir -p $LINDERA_CACHE/${linderaVersion}

    ${lib.concatMapStringsSep "\n" (dict: ''
      echo "Copying ${dict.language} dictionary to Lindera cache"
      cp ${dict.source} $LINDERA_CACHE/${linderaVersion}/${dict.filename}
    '') (lib.attrValues dictionaries)}

    echo "Lindera cache prepared at $LINDERA_CACHE"
  '';

  # https://github.com/paradedb/paradedb/blob/v0.21.0/Cargo.toml#L36-L37
  cargo-pgrx = cargo-pgrx_0_16_1;

  # https://github.com/paradedb/paradedb/tree/v0.21.0/pg_search
  cargoPgrxFlags = [
    "--package"
    "pg_search"
  ];

  # Tests fail on Darwin because pgrx attempts to write the .control file to the Nix store
  doCheck = !stdenv.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Transactional Elasticsearch alternative as a PostgreSQL extension";
    homepage = "https://paradedb.com";
    changelog = "https://github.com/paradedb/paradedb/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.lucperkins ];
    # https://github.com/paradedb/paradedb/blob/v0.21.0/pg_search/Cargo.toml#L14-L18
    broken = lib.versionOlder postgresql.version "14";
    platforms = postgresql.meta.platforms;
  };
})
