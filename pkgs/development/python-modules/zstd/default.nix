{ lib, pkg-config, fetchPypi, buildPythonPackage
, buildPackages
, zstd, pytest }:

buildPythonPackage rec {
  pname = "zstd";
  version = "1.5.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PEKbFmo7MksJg7/1OuCSi5dkxpOgF/Yv+2sg5hNeM48=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/bin/pkg-config" "${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ zstd ];

  setupPyBuildFlags = [
    "--external"
    "--include-dirs=${zstd}/include"
    "--libraries=zstd"
    "--library-dirs=${zstd}/lib"
  ];

  # Running tests via setup.py triggers an attempt to recompile with the vendored zstd
  ZSTD_EXTERNAL = 1;
  VERSION = zstd.version;
  PKG_VERSION = version;

  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Simple python bindings to Yann Collet ZSTD compression library";
    homepage = "https://github.com/sergey-dryabzhinsky/python-zstd";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
