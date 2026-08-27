{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  textual,
}:

buildPythonPackage (finalAttrs: {
  pname = "textual-slider";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "TomJGooding";
    repo = "textual-slider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y/QKN89IWEdO9bTBQ3RFhrYShganUBQ6O5+HgsITFH0=";
  };

  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [ textual ];

  meta = {
    description = "Textual widget for a simple slider";
    homepage = "https://github.com/TomJGooding/textual-slider";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.lukegb ];
  };
})
