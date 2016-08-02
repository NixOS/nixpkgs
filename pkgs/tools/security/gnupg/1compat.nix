{ stdenv, gnupg, coreutils, writeScript }:

stdenv.mkDerivation {
  name = "gnupg1compat-0";

  builder = writeScript "gnupg1compat-builder" ''
    # First symlink all top-level dirs
    ${coreutils}/bin/mkdir -p $out
    ${coreutils}/bin/ln -s "${gnupg}/"* $out

    # Replace bin with directory and symlink it contents
    ${coreutils}/bin/rm $out/bin
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/ln -s "${gnupg}/bin/"* $out/bin

    # Add gpg->gpg2 and gpgv->gpgv2 symlinks
    ${coreutils}/bin/ln -s gpg2 $out/bin/gpg
    ${coreutils}/bin/ln -s gpgv2 $out/bin/gpgv
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
