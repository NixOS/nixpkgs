{ stdenv, pkgconfig, fetchPypi, buildPythonPackage
, zstd, pytest }:

buildPythonPackage rec {
  pname = "zstd";
  version = "1.4.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2a1806d625bd2d8944ead4b3018fc6444a31467fa09935e9c1d4296275f024c6";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/bin/pkg-config" "${pkgconfig}/bin/${pkgconfig.targetPrefix}pkg-config"
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
