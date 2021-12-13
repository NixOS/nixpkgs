{ lib, stdenv, fetchurl, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "patchelf-${version}";
  version = "unstable-2021-12-07";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "fbf108f581cb723eff58c1d82aae6bae10820f80";
    sha256 = "sha256-wRj/dx27nEau5/8g1n+S5ppqq7+kDmBqdGw97WP2Vo8=";
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
