{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colormath,
}:

buildPythonPackage rec {
  pname = "spectra";
  version = "0.0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jsvine";
    repo = "spectra";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4A2TWTxYqckJ3DX5cd2KN3KXcmO/lQdXmOEnGi76RsA=";
  };

  dependencies = [ colormath ];

  build-system = [ setuptools ];

  postInstall = "install -Dm755 $src/spectra/grapefruit.py $out/bin/grapefruit.py";

  doCheck = false; # tests require nose. An outdated python library.

  # pytestFlagsArray = [ "-W 'ignore:pkg_resources is deprecated as an API:DeprecationWarning'" ];

  pythonImportsCheck = [ "spectra" ];

  meta = {
    description = "Provides tools for color math, scales, and color-space conversions";
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
    changelog = "https://github.com/jsvine/spectra/releases/tag/v${version}/";
    maintainers = [ lib.maintainers.dflores ];
    license = with lib.licenses; [
      mit
      asl20 # grapefruit.py
    ];
    platforms = lib.platforms.unix;
  };

}
