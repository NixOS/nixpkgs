{ stdenv, pkgconfig, fetchPypi, buildPythonPackage
, buildPackages
, zstd, pytest }:

buildPythonPackage rec {
  pname = "zstd";
  version = "1.4.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b62b21eb850abd6b8c0046bfc1c5c773c873eeb94f1904ef1ff304e98b62b80e";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/bin/pkg-config" "${buildPackages.pkgconfig}/bin/${buildPackages.pkgconfig.targetPrefix}pkg-config"
  '';

  nativeBuildInputs = [ pkgconfig ];
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

  meta = with stdenv.lib; {
    description = "Simple python bindings to Yann Collet ZSTD compression library";
    homepage = "https://github.com/sergey-dryabzhinsky/python-zstd";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
