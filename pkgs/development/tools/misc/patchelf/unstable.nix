{ lib, stdenv, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2025-01-07";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "43b75fbc9ffbc1190fee7c8693ad74cb8286cfd4";
    sha256 = "sha256-rqFH9xUu36Hky763cQ9D1V7iuWteItAFDM2jIQGP5Us=";
  };

  # Drop test that fails on musl (?)
  postPatch = lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/NixOS/patchelf.git";
    };
  };

  meta = with lib; {
    homepage = "https://github.com/NixOS/patchelf";
    license = licenses.gpl3;
    description = "Small utility to modify the dynamic linker and RPATH of ELF executables";
    mainProgram = "patchelf";
    maintainers = [ ];
    platforms = platforms.all;
  };
}
