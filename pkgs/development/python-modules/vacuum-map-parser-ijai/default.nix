{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
  protobuf,
  pycryptodome,
  vacuum-map-parser-base,
}:

buildPythonPackage (finalAttrs: {
  pname = "vacuum-map-parser-ijai";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maksp86";
    repo = "Python-package-vacuum-map-parser-ijai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SF5v4QlOHV4JSZgawW6XW08wQWXPCeP1oXwlKrHhkKs=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${finalAttrs.version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    # not declared upstream, imported by the generated RobotMap_pb2
    protobuf
    pycryptodome
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "vacuum_map_parser_ijai"
    "vacuum_map_parser_ijai.map_data_parser"
  ];

  meta = {
    description = "Functionalities for Ijai vacuum map parsing";
    homepage = "https://github.com/maksp86/Python-package-vacuum-map-parser-ijai";
    changelog = "https://github.com/maksp86/Python-package-vacuum-map-parser-ijai/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
