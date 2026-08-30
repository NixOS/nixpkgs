{
  lib,
  stdenv,
  gnupg,
  coreutils,
  writeScript,
}:

stdenv.mkDerivation {
  pname = "gnupg1compat";
  inherit (gnupg) version outputs;

  builder = writeScript "gnupg1compat-builder" (
    ''
      PATH=${coreutils}/bin
    ''
    # First symlink all top-level dirs, output per output
    + lib.concatMapStringsSep "\n" (o: ''
      mkdir -p ''$${o}
      ln -s "${gnupg.${o}}/"* ''$${o}
    '') gnupg.outputs
    + ''

      # Replace bin with directory and symlink it contents
      rm ''${!outputBin}/bin
      mkdir -p ''${!outputBin}/bin
      ln -s "${lib.getBin gnupg}/bin/"* ''${!outputBin}/bin

      # Add symlinks for any executables that end in 2 and lack any non-*2 version
      for f in ''${!outputBin}/bin/*2; do
        [[ -x $f ]] || continue # ignore failed globs and non-executable files
        [[ -e ''${f%2} ]] && continue # ignore commands that already have non-*2 versions
        ln -s -- "''${f##*/}" "''${f%2}"
      done
    ''
  );

  meta = gnupg.meta // {
    description = gnupg.meta.description + " with symbolic links for gpg and gpgv";
    priority = -1;
  };
}
