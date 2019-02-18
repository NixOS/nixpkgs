{ stdenv, pkgconfig, fetchpatch, fetchPypi, buildPythonPackage
, zstd, pytest }:

buildPythonPackage rec {
  pname = "zstd";
  version = "1.3.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d89e884da59c35e480439f1663cb3cb4cf372e42ba0eb0bdf22b9625414702a3";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/bin/pkg-config" "${pkgconfig}/bin/pkg-config"
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
    homepage = https://github.com/sergey-dryabzhinsky/python-zstd;
    license = licenses.bsd2;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
