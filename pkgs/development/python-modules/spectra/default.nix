{ lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colormath,
  nose
}:

buildPythonPackage rec {
  pname = "spectra";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo  = "spectra";
    rev = "v${version}";
    hash = "sha256-4A2TWTxYqckJ3DX5cd2KN3KXcmO/lQdXmOEnGi76RsA=";
  };

  build-system = [ setuptools ];

  dependencies = [ colormath ];

  nativeCheckInputs = [ nose ];
  checkPhase = "nosetests";

  meta = {
    description = "Spectra is a Python library that makes color math, color scales, and color-space conversion easy";
    longDescription = ''
    Spectra has support for:

    * Color scales
    * Color ranges
    * Color blending
    * Brightening/darkening colors
    * Saturating/desaturating colors
    * Conversion to/from multiple color spaces

    Spectra is built on colormath and grapefruit. Spectra is enormously inspired by chroma.js and d3's scales.
    '';
    homepage = "https://github.com/jsvine/spectra";
    changelog = "https://github.com/jsvine/spectra/releases/tag/v${version}";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dflores ];
    platforms = lib.platforms.unix;
  };

}
