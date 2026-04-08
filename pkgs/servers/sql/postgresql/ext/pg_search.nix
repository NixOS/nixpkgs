{
  buildPgrxExtension,
  cargo-pgrx_0_17_0,
  fetchFromGitHub,
  fetchurl,
  lib,
  nix-update-script,
  pkg-config,
  postgresql,
}:

buildPgrxExtension (finalAttrs: {
  pname = "pg_search";
  version = "0.22.5";

  src = fetchFromGitHub {
    owner = "paradedb";
    repo = "paradedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b5sdKEWy4/uXLIE6HtcRMihtRK9iO9jM8pvktO3rOUU=";
  };

  cargoHash = "sha256-Umbx1ZrQEYifp09+unfaN/MBcbSq16NcqhP6h703Sb8=";

  inherit postgresql;

  preConfigure =
    let
      # Lindera dictionaries are copied to a temporary directory and the
      # LINDERA_CACHE environment variable prevents the build.rs files in
      # the Lindera crates from downloading their dictionary from an
      # external URL, which doesn't work in the Nix sandbox.

      # You can see which Lindera version pg_search is using here:
      # https://github.com/paradedb/paradedb/tree/${version}/Cargo.lock
      linderaVersion = "1.5.1";

      # pg_search's tokenizer uses several language dictionaries used by the Lindera crate
      # Check the relevant build.rs files to get the proper URLs:
      # https://github.com/lindera/lindera/blob/${linderaVersion}/${dictionaryKey}/build.rs
      # Here's an example URL:
      # https://github.com/lindera/lindera/blob/v1.5.1/lindera-cc-cedict/build.rs

      dict = language: filename: hash: {
        inherit filename language;
        source = fetchurl {
          url = "https://lindera.dev/${filename}";
          inherit hash;
        };
      };

      dictionaries = {
        lindera-ko-dic =
          dict "Korean" "mecab-ko-dic-2.1.1-20180720.tar.gz"
            "sha256-cCztIcYWfp2a68Z0q17lSvWNREOXXylA030FZ8AgWRo=";
        lindera-cc-cedict =
          dict "Chinese" "CC-CEDICT-MeCab-0.1.0-20200409.tar.gz"
            "sha256-7Tz54+yKgGR/DseD3Ana1DuMytLplPXqtv8TpB0JFsg=";
        lindera-ipadic =
          dict "Japanese" "mecab-ipadic-2.7.0-20250920.tar.gz"
            "sha256-p7qfZF/+cJTlauHEqB0QDfj7seKLvheSYi6XKOFi2z0=";
      };
    in
    ''
      export LINDERA_CACHE=$TMPDIR/lindera-cache
      mkdir -p $LINDERA_CACHE/${linderaVersion}
      ${lib.concatMapStringsSep "\n" (dict: ''
        echo "Copying ${dict.language} dictionary to Lindera cache"
        cp ${dict.source} $LINDERA_CACHE/${linderaVersion}/${dict.filename}
      '') (lib.attrValues dictionaries)}
      echo "Lindera cache prepared at $LINDERA_CACHE"
    '';

  # To determinate which version of cargo-pgrx to use, consult the project's main Cargo.toml:
  # https://github.com/paradedb/paradedb/tree/${version}/Cargo.toml
  # In that file, check the version of pgrx and pgrx-tests under workspace.dependencies
  cargo-pgrx = cargo-pgrx_0_17_0;

  cargoPgrxFlags = [
    "--package"
    "pg_search"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # pgrx tests try to install the extension into postgresql nix store
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Transactional Elasticsearch alternative as a PostgreSQL extension";
    homepage = "https://paradedb.com";
    changelog = "https://github.com/paradedb/paradedb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.lucperkins ];
    # For a list of versions, look under the features dictionary in:
    # https://github.com/paradedb/paradedb/tree/${version}/pg_search/Cargo.toml
    broken = lib.versionOlder postgresql.version "15";
    platforms = postgresql.meta.platforms;
  };
})
