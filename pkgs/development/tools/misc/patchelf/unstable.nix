{ lib, stdenv, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "0.18.0-unstable-2024-01-15";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "7c2f768bf9601268a4e71c2ebe91e2011918a70f";
    sha256 = "sha256-PPXqKY2hJng4DBVE0I4xshv/vGLUskL7jl53roB8UdU=";
  };

  # Drop test that fails on musl (?)
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.isDarwin;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/NixOS/patchelf.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/NixOS/patchelf";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
