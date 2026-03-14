{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  pillow,
  vacuum-map-parser-base,
  pycryptodome,
}:

buildPythonPackage rec {
  pname = "vacuum-map-parser-ijai";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "maksp86";
    repo = "Python-package-${pname}";
    tag = "v${version}";
    hash = "sha256-mxLEfpifPBR5gYbxskpviaj4k7S2OImh0wyfpy6aXv0=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    pillow
    pycryptodome
    vacuum-map-parser-base
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_ijai" ];

  meta = {
    description = "Functionalities for Ijai vacuum map parsing";
    homepage = "https://github.com/maksp86/Python-package-vacuum-map-parser-ijai";
    changelog = "https://github.com/maksp86/Python-package-vacuum-map-parser-ijai/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ dady8889 ];
    license = lib.licenses.asl20;
  };
}
