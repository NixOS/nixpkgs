{
  lib,
  buildPythonPackage,
  dateparser,
  defusedxml,
  fetchFromGitHub,
  geomet,
  geopandas,
  kml2geojson,
  pyshp,
  pythonOlder,
  pyyaml,
  requests,
  setuptools-scm,
  shapely,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "wktutils";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asfadmin";
    repo = "Discovery-WKTUtils";
    rev = "refs/tags/v${version}";
    hash = "sha256-mB+joEZq/aFPcRqFAzPgwG26Wi7WiRCeQeFottk+4Ho=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"twine",' ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    dateparser
    defusedxml
    geomet
    geopandas
    kml2geojson
    pyshp
    pyyaml
    shapely
  ];

  optional-dependencies = {
    extras = [
      requests
      scikit-learn
    ];
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "WKTUtils" ];

  meta = with lib; {
    description = "Collection of tools for handling WKTs";
    homepage = "https://github.com/asfadmin/Discovery-WKTUtils";
    changelog = "https://github.com/asfadmin/Discovery-WKTUtils/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
