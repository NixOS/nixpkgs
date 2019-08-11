{ stdenv, fetchurl, autoreconfHook, texinfo, buggyBiosCDSupport ? true }:

stdenv.mkDerivation {
  name = "grub-0.97-73";

  src = fetchurl {
    url = https://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz;
    sha256 = "02r6b52r0nsp6ryqfiqchnl7r1d9smm80sqx24494gmx5p8ia7af";
  };

  patches = [
    # Properly handle the case of symlinks such as
    # /dev/disk/by-label/bla.  The symlink resolution code in
    # grub-install isn't smart enough.
    ./symlink.patch
  ]
  ++ (stdenv.lib.optional buggyBiosCDSupport ./buggybios.patch)
  ++ map fetchurl (import ./grub1.patches.nix)
  ;

  # autoreconfHook required for the splashimage patch.
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ texinfo ];

  hardeningDisable = [ "format" "stackprotector" ];

  passthru.grubTarget = "";

  meta = with stdenv.lib; {
    homepage = https://www.gnu.org/software/grub;
    description = "GRand Unified Bootloader";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
