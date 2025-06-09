{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  rustPlatform,
  openssl,
  pkg-config,
  aiohttp,
  boto3,
  click,
  py4j,
  psutil,
  protobuf,
  grpcio-tools,
  mypy-protobuf,
  swh-core,
  swh-model,
  flask,
  msgpack,
  pytestCheckHook,
  pytest-postgresql,
  pytest-shared-session-scope,
  pytest-xdist,
  swh-storage,
  pkgs,
}:

let
  version = "6.7.1";

  swh-graph-rust = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "swh-graph-rust";
    inherit version;

    src = fetchFromGitLab {
      domain = "gitlab.softwareheritage.org";
      group = "swh";
      owner = "devel";
      repo = "swh-graph";
      tag = "v${finalAttrs.version}";
      hash = "sha256-4VeveNEBdCKiam8PbufyyiTNIbZJr6YUkd9utQS+mD4=";
    };

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      openssl
      protobuf
    ];

    useFetchCargoVendor = true;
    cargoHash = "sha256-veB2CrzT0U5zcggY9oZYkaoXBkDnKtJS8aZBAPvZkoQ=";

    cargoTestFlags = [ "--workspace" ];
  });
in
buildPythonPackage rec {
  pname = "swh-graph";
  inherit version;
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-graph";
    tag = "v${version}";
    hash = "sha256-4VeveNEBdCKiam8PbufyyiTNIbZJr6YUkd9utQS+mD4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    boto3
    click
    py4j
    psutil
    protobuf
    grpcio-tools
    mypy-protobuf
    swh-core
    swh-model
    swh-graph-rust
  ];

  pythonImportsCheck = [ "swh.graph" ];

  nativeCheckInputs = [
    flask
    msgpack
    pytestCheckHook
    pytest-postgresql
    pytest-shared-session-scope
    pytest-xdist
    swh-graph-rust
    swh-storage
    pkgs.zstd
  ];

  meta = {
    description = "Tooling and services providing fast access to the graph representation of the Software Heritage archive";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-graph";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
