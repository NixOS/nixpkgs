{ lib, stdenv, fetchFromGitHub, m4, pkg-config, tcl
, bzip2, elfutils, libarchive, libbsd, xz, openssl, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkg";
<<<<<<< HEAD
  version = "1.20.5";
=======
  version = "1.19.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "pkg";
    rev = finalAttrs.version;
<<<<<<< HEAD
    sha256 = "sha256-svAxEBRnqwWhmu3aRfeGeEjXfADbb1zWPj+REK9fsDM=";
=======
    sha256 = "WHR2evPn4Y0wzGwVUEuYPrDDnuPSsYHr4xIofAHeTJk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  };
})
