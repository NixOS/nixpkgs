{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  dom-toml,
  whey,
}:
buildPythonPackage rec {
  pname = "whey-pth";
  version = "0.0.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CIpgqzNXW3VpS+k6BCpc2DNyqwgt/Af3ms59AH/V5KM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    dom-toml
    whey
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools!=61.*,<=67.1.0,>=40.6.0"' '"setuptools"'
  '';

  meta = {
    description = "Extension to whey to support .pth files.";
    homepage = "https://pypi.org/project/whey-pth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
