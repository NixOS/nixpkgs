{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "patchelf-0.10-pre-20170217";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "c1f89c077e44a495c62ed0dcfaeca21510df93ef";
    sha256 = "07vx75f2r1bh58qj4b6bl27v39srs2rfr1jrif7syspfhkn4qzw4";
  };

  setupHook = [ ./setup-hook.sh ];

  buildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = {
    homepage = https://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
