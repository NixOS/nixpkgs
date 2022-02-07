{ lib, stdenv, fetchurl, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "patchelf";
  version = "2021-11-16";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "a174cf3006baf31e0e9eaa62bc9adead93af63f7";
    sha256 = "sha256-cKZ4DE70R5XiIqfnIVAl2s7a1bJxaaPpuCmxs3pxFRU=";
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

  meta = with lib; {
    homepage = "https://github.com/NixOS/patchelf";
    license = licenses.gpl3;
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
