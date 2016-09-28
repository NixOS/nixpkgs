{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "patchelf-0.10-pre-20160920";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "patchelf";
    rev = "327d80443672c397970738f9e216a7e86cbf3ad7";
    sha256 = "0nghzywda4jrj70gvn4dnrzasafgdp0basj04wfir1smvsi047zr";
  };

  setupHook = [ ./setup-hook.sh ];

  buildInputs = [ autoreconfHook ];

  doCheck = true;

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
