{ lib, stdenv, fetchFromGitHub, m4, pkg-config, tcl
, bzip2, elfutils, libarchive, libbsd, xz, openssl, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkg";
  version = "1.20.8";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "pkg";
    rev = finalAttrs.version;
    sha256 = "sha256-pQgZMCd4PEjNZKm9V35Rca7Miblv1EgkH+CxaiKvhpY=";
  };

  setOutputFlags = false;
  separateDebugInfo = true;

  nativeBuildInputs = [ m4 pkg-config tcl ];
  buildInputs = [ bzip2 elfutils libarchive openssl xz zlib ]
    ++ lib.optional stdenv.isLinux libbsd;

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/etc
  '';

  meta = with lib; {
    homepage = "https://github.com/freebsd/pkg";
    description = "Package management tool for FreeBSD";
    maintainers = with maintainers; [ qyliss ];
    platforms = with platforms; darwin ++ freebsd ++ linux ++ netbsd ++ openbsd;
    license = licenses.bsd2;
    mainProgram = "pkg";
  };
})
