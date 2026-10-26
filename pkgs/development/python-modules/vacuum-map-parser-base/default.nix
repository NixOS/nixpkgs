{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pillow,
}:

buildPythonPackage (finalAttrs: {
  pname = "vacuum-map-parser-base";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PiotrMachowski";
    repo = "Python-package-${finalAttrs.pname}";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jB3/m2qlaDnc9fVTlM0wR2ROZmJQ1h6a+awauOa312g=";
  };

  postPatch = ''
    # Upstream doesn't set a version in the pyproject.toml file
    substituteInPlace pyproject.toml \
      --replace "0.0.0" "${finalAttrs.version}"
  '';

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ pillow ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "vacuum_map_parser_base" ];

  meta = {
    homepage = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-base";
    description = "Common code for vacuum map parsers";
    changelog = "https://github.com/PiotrMachowski/Python-package-vacuum-map-parser-base/releases/tag/${finalAttrs.src.tag}";
    maintainers = with lib.maintainers; [ jamiemagee ];
    license = lib.licenses.asl20;
  };
})
