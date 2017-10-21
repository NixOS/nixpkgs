{ stdenv, gnupg, coreutils, writeScript }:

stdenv.mkDerivation {
  name = "gnupg1compat-${gnupg.version}";

  builder = writeScript "gnupg1compat-builder" ''
    # First symlink all top-level dirs
    ${coreutils}/bin/mkdir -p $out
    ${coreutils}/bin/ln -s "${gnupg}/"* $out

    # Replace bin with directory and symlink it contents
    ${coreutils}/bin/rm $out/bin
    ${coreutils}/bin/mkdir -p $out/bin
    ${coreutils}/bin/ln -s "${gnupg}/bin/"* $out/bin
  '';

  meta = gnupg.meta // {
    description = gnupg.meta.description +
      " with symbolic links for gpg and gpgv";
    priority = -1;
  };
}
