{
  lib,
  pkg-config,
  fetchPypi,
  buildPythonPackage,
  setuptools,
  buildPackages,
  zstd,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "zstd";
  version = "1.5.7.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-QD5SBfSsBLkuawzaZUvi9R3iaCKKDbAGe8CH+qzy9JU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/bin/pkg-config" "${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zstd ];

  setupPyBuildFlags = [
    "--external"
    "--include-dirs=${zstd}/include"
    "--libraries=zstd"
    "--library-dirs=${zstd}/lib"
  ];

  env = {
    # Running tests via setup.py triggers an attempt to recompile with the vendored zstd
    ZSTD_EXTERNAL = 1;
    VERSION = zstd.version;
    PKG_VERSION = finalAttrs.version;
  };

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "zstd" ];

  meta = {
    description = "Simple python bindings to Yann Collet ZSTD compression library";
    homepage = "https://github.com/sergey-dryabzhinsky/python-zstd";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ eadwu ];
  };
})
