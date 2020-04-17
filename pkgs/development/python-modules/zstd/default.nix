{ stdenv, pkgconfig, fetchPypi, buildPythonPackage
, zstd, pytest }:

buildPythonPackage rec {
  pname = "zstd";
  version = "1.4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "33f2c1fd8d3f9ac8e35fb3e199896afc54cceb68878570c6d4b72985dc6584a5";
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
    homepage = "https://github.com/sergey-dryabzhinsky/python-zstd";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
