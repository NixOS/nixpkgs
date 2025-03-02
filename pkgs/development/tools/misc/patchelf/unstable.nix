{ lib, stdenv, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "523f401584d9584e76c9c77004e7abeb9e6c4551";
    sha256 = "sha256-KYFHARMXv4cXJezf41enxmU8MX1RWP4L2E7Ueq6mtRM=";
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
