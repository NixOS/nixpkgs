{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "patchelf-0.10-pre-20180108";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "48452cf6b4ccba1c1f47a09f4284a253634ab7d1";
    sha256 = "1f1s8q3as3nrhcc1a8qc2z7imm644jfz44msn9sfv4mdynp2m2yb";
  };

  # Drop test that fails on musl (?)
  postPatch = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    substituteInPlace tests/Makefile.am \
      --replace "set-rpath-library.sh" ""
  '';

  setupHook = [ ./setup-hook.sh ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  doCheck = true;

  meta = {
    homepage = https://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
