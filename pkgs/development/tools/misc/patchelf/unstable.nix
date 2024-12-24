{ lib, stdenv, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "patchelf";
  version = "0.18.0-unstable-2024-11-18";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "769337c227799aa60911562b6940530f4a86eb3c";
    sha256 = "sha256-eOHQ7pD8OfSLIIFfF6daCnntzHKqpraAGFfFqSlPtbY=";
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
