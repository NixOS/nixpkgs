{ lib, stdenv, fetchurl, autoreconfHook, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "unstable-2023-09-19";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "afd3cc94450dc6845e923f9221fa38818538219e";
    sha256 = "sha256-ZTy3Dw2HkKokBUXz3ftoGCYncVQ/K3lons9mIt+HVvQ=";
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
