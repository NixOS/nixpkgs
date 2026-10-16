{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  cargo,
  rustc,
  rustPlatform,

  # build-system
  hatchling,

  # dependencies
  atpublic,
  attrs,
  cityhash,
  cloudpickle,
  cryptography,
  dask,
  datafusion,
  duckdb,
  envyaml,
  filelock,
  geoarrow-types,
  git-annex,
  gitpython,
  ibis-framework,
  opentelemetry-exporter-otlp,
  opentelemetry-exporter-otlp-proto-grpc,
  opentelemetry-exporter-prometheus,
  pandas,
  parsy,
  psycopg2,
  py-yaml12,
  pyarrow,
  pyiceberg,
  pythran,
  pytz,
  rich,
  snowflake-connector-python,
  sqlglot,
  structlog,
  textual,
  tomlkit,
  uv,
}:

let
  # this package is intended only for internal use by xorq:
  # https://github.com/xorq-labs/xorq-datafusion
  xorq-datafusion = buildPythonPackage (finalAttrs: {
    pname = "xorq-datafusion";
    version = "0.2.5";
    pyproject = true;

    disabled = pythonOlder "3.10";

    src = fetchPypi {
      inherit (finalAttrs) version;
      pname = "xorq_datafusion";
      hash = "sha256-PoHmnFhVZJStNyj44n+9v3ecpn/OM5gMhOl9u2aIPnA=";
    };

    postPatch = ''
      rm -f rust-toolchain.toml
    '';

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-FMP+29LUFsB92cIyl1YJSrKSRymgKZtCJOiU/8SK/o0=";
    };

    nativeBuildInputs = [
      cargo
      rustc
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
    ];

    dependencies = [
      pyarrow
    ];

    pythonRelaxDeps = [
      "pyarrow"
    ];

    pythonImportsCheck = [ "xorq_datafusion" ];
  });
in
buildPythonPackage (finalAttrs: {
  pname = "xorq";
  version = "0.3.23";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-c64yiZQ74cOErI7iNA0YnECXqCYoKnO0SgzvzvtOj18=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    atpublic
    attrs
    cityhash
    cloudpickle
    cryptography
    dask
    envyaml
    filelock
    geoarrow-types
    git-annex
    gitpython
    opentelemetry-exporter-otlp
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-exporter-prometheus
    pandas
    parsy
    py-yaml12
    pyarrow
    pythran
    pytz
    rich
    snowflake-connector-python
    sqlglot
    structlog
    textual
    tomlkit
    uv
    xorq-datafusion
  ];

  pythonRelaxDeps = [
    "atpublic"
    "dask"
    "opentelemetry-exporter-prometheus"
    "pyarrow"
    "sqlglot"
  ];

  pythonRemoveDeps = [ "git-annex" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ git-annex ])
  ];

  optional-dependencies = {
    datafusion = [ datafusion ];
    duckdb = [ duckdb ];
    ibis = [ ibis-framework ];
    pyiceberg = [
      pyiceberg
    ]
    ++ pyiceberg.optional-dependencies.sql-sqlite
    ++ pyiceberg.optional-dependencies.sql-postgres;
    snowflake = [ snowflake-connector-python ];

    # Not yet available:
    # bsl = [ boring-semantic-layer ];
    # databricks = [ adbc-driver-manager databricks-sql-connector ];
    # gizmosql = [ adbc-driver-gizmosql duckdb ];
    # postgres = [ adbc-driver-postgresql psycopg ];
    # sqlite = [ adbc-driver-sqlite ];
    # trino = [ trino ];
  };

  pythonImportsCheck = [ "xorq" ];

  meta = {
    description = "Compute manifest and composable tools for ML, built on Ibis, DataFusion, and Arrow Flight";
    homepage = "https://xorq.dev";
    changelog = "https://github.com/xorq-labs/xorq/blob/main/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "xorq";
    maintainers = with lib.maintainers; [ lucperkins ];
  };
})
