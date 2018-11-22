{ stdenv, pkgconfig, fetchpatch, fetchFromGitHub, buildPythonPackage
, zstd, pytest }:

buildPythonPackage rec {
  pname = "zstd";
  version = "1.3.5.1";

  # Switch back to fetchPypi when tests/ is included, see https://github.com/NixOS/nixpkgs/pull/49339
  src = fetchFromGitHub {
    owner = "sergey-dryabzhinsky";
    repo = "python-zstd";
    rev = "v${version}";
    sha256 = "08n1vz4zavas4cgzpdfcbpy33lnv39xxhq5mgj0zv3xi03ypc1rl";
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
