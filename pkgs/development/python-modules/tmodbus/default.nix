{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  rustPlatform,
  serialx,
  socat,
  tenacity,
}:

let
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "wlcrs";
    repo = "tmodbus";
    tag = "v${version}";
    hash = "sha256-pVP2QaCYkeeKhlEha7qIyNhbN1DfVyRxTSZBloEMXxc=";
  };

  rmodbus-server = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "rmodbus-server";
    version = "0.1.0";

    inherit src;

    sourceRoot = "${src.name}/integration_tests/rmodbus";

    cargoHash = "sha256-t7lJ7zC5+z1E/EDWTPR6cbGhcy/RmtXQXon+FiXRZlI=";

    meta = {
      description = "Rust Modbus server";
      license = lib.licenses.bsd3;
      mainProgram = "server";
    };
  });

  tokio-modbus-server = rustPlatform.buildRustPackage (finalAttrs: {
    pname = "tokio-modbus-server";
    version = "0.1.0";

    inherit src;

    sourceRoot = "${src.name}/integration_tests/tokio";

    cargoHash = "sha256-grYnQxf0CH7hkFq1zTMxw6brtHfCheh/O2EtPPPpVqA=";

    meta = {
      description = "Rust Tokio Modbus server";
      license = lib.licenses.bsd3;
      mainProgram = "tokio-server";
    };
  });
in

buildPythonPackage (finalAttrs: {
  pname = "tmodbus";
  inherit version src;
  pyproject = true;

  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace \
      integration_tests/tokio/test_tokio_client.py \
      integration_tests/rmodbus/test_rmodbus_client.py \
      --replace-fail "/usr/bin/socat" "${lib.getExe socat}"

    mkdir -p integration_tests/{rmodbus,tokio}/target/release
    ln -s ${lib.getExe' rmodbus-server "ascii-server"} integration_tests/rmodbus/target/release/
    ln -s ${lib.getExe rmodbus-server} integration_tests/rmodbus/target/release/
    ln -s ${lib.getExe tokio-modbus-server} integration_tests/tokio/target/release/
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  optional-dependencies = {
    async-serial = [
      serialx
    ];
    smart = [
      tenacity
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [
    "tmodbus"
  ];

  passthru = {
    inherit rmodbus-server tokio-modbus-server;
  };

  meta = {
    description = "Modern Python Modbus library";
    homepage = "https://github.com/wlcrs/tmodbus";
    changelog = "https://github.com/wlcrs/tmodbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
    badPlatforms = [
      "aarch64-darwin" # tests fail, no indication they should work
    ];
  };
})
