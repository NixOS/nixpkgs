{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "patchelf-0.10-pre-20180108";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "48452cf6b4ccba1c1f47a09f4284a253634ab7d1";
    sha256 = "07vx75f2r1bh58qj4b6bl27v39srs2rfr1jrif7syspfhkn4qzw4";
  };

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
