{
  buildPgrxExtension,
  cargo-pgrx_0_15_0,
  fetchFromGitHub,
  fetchurl,
  lib,
  nix-update-script,
  postgresql,
}:

let
  # corresponds to the version of pgrx* packages in the workspace Cargo.lock:
  # https://github.com/paradedb/paradedb/blob/v0.19.5/Cargo.lock#L3228-L3230
  cargoPgrxPkg = cargo-pgrx_0_15_0;

  # https://github.com/paradedb/paradedb/blob/v0.19.5/Cargo.lock#L2588-L2616
  linderaVersion = "0.43.3";
  linderaWebsite = "https://lindera.dev";

  # pg_search's tokenizer uses several language dictionaries used by the Lindera crate
  dictionaries = {
    # https://github.com/lindera/lindera/blob/v0.43.3/lindera-ko-dic/build.rs#L14
    lindera-ko-dic = rec {
      language = "Korean";
      filename = "mecab-ko-dic-2.1.1-20180720.tar.gz";
      source = fetchurl {
        url = "${linderaWebsite}/${filename}";
        hash = "sha256-cCztIcYWfp2a68Z0q17lSvWNREOXXylA030FZ8AgWRo=";
      };
    };

    # https://github.com/lindera/lindera/blob/v0.43.3/lindera-cc-cedict/build.rs#L14
    lindera-cc-cedict = rec {
      language = "Chinese";
      filename = "CC-CEDICT-MeCab-0.1.0-20200409.tar.gz";
      source = fetchurl {
        url = "${linderaWebsite}/${filename}";
        hash = "sha256-7Tz54+yKgGR/DseD3Ana1DuMytLplPXqtv8TpB0JFsg=";
      };
    };

    # https://github.com/lindera/lindera/blob/v0.43.3/lindera-ipadic/build.rs#L14
    lindera-ipadic = rec {
      language = "Japanese";
      filename = "mecab-ipadic-2.7.0-20070801.tar.gz";
      source = fetchurl {
        url = "${linderaWebsite}/${filename}";
        hash = "sha256-CZ5G6A1V58DWkGeDr/cTdI4a6Q9Gxe+W7BU7vwm/VVA";
      };
    };
  };
in
buildPgrxExtension (finalAttrs: {
  pname = "pg_search";
  version = "0.19.5";

  src = fetchFromGitHub {
    owner = "paradedb";
    repo = "paradedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/7AHKUUJW1wh39pUXlVEIykobE2IRMul3pWxoUCdKjA=";
  };

  cargoHash = "sha256-Yn4D8oaENExqzx1p/9OTEKsVnlJDitn1JST6rhHGPrw=";

  inherit postgresql;

  # Lindera dictionaries are copied to a temporary directory and the
  # LINDERA_CACHE environment variable prevents the build.rs files in
  # the Lindera crates from downloading their dictionary from an
  # external URL, which doesn't work in the Nix sandbow
  preConfigure = ''
    export LINDERA_CACHE=$TMPDIR/lindera-cache
    mkdir -p $LINDERA_CACHE/${linderaVersion}

    ${lib.concatMapStringsSep "\n" (dict: ''
      echo "Copying ${dict.language} dictionary to Lindera cache"
      cp ${dict.source} $LINDERA_CACHE/${linderaVersion}/${dict.filename}
    '') (lib.attrValues dictionaries)}

    echo "Lindera cache prepared at $LINDERA_CACHE"
  '';

  cargo-pgrx = cargoPgrxPkg;

  # https://github.com/paradedb/paradedb/tree/v0.19.5/pg_search
  cargoPgrxFlags = [
    "--package"
    "pg_search"
  ];

  # tests don't pass on darwin and not yet tried on Linux
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Transactional Elasticsearch alternative as a PostgreSQL extension";
    homepage = "https://paradedb.com";
    changelog = "https://github.com/paradedb/paradedb/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.lucperkins ];
    broken = lib.versionOlder postgresql.version "14" || lib.versionAtLeast postgresql.version "18";
    platforms = postgresql.meta.platforms;
  };
})
