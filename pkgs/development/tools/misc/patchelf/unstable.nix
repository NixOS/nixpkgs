{ lib, stdenv, fetchurl, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "unstable-2022-07-16";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "c2b419dc2a0d6095eaa69b65ad5854ce847bdd01";
    sha256 = "sha256-8U3EFO6nKTpPurrmdT3SjwiuU07Aztrp71Oe3CLQvcw=";
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
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
