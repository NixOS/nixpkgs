{ lib, stdenv, fetchurl, autoreconfHook, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "patchelf-${version}";
  version = "2020-07-11";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "126372b636733b160e693c9913e871f6755c02e";
    sha256 = "07cn40ypys5pyc3jfgxvqj7qk5v6m2rr5brnpmxdsl1557ryx226";
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
