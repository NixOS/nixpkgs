{
  stdenv,
  gnupg,
  coreutils,
  writeScript,
}:

stdenv.mkDerivation {
  pname = "gnupg1compat";
  version = gnupg.version;

  builder = writeScript "gnupg1compat-builder" ''
    PATH=${coreutils}/bin
    # First symlink all top-level dirs
    mkdir -p $out
    ln -s "${gnupg}/"* $out

    # Replace bin with directory and symlink it contents
    rm $out/bin
    mkdir -p $out/bin
    ln -s "${gnupg}/bin/"* $out/bin

    # Add symlinks for any executables that end in 2 and lack any non-*2 version
    for f in $out/bin/*2; do
      [[ -x $f ]] || continue # ignore failed globs and non-executable files
      [[ -e ''${f%2} ]] && continue # ignore commands that already have non-*2 versions
      ln -s -- "''${f##*/}" "''${f%2}"
    done
  '';

  meta = gnupg.meta // {
    description = gnupg.meta.description + " with symbolic links for gpg and gpgv";
    priority = -1;
  };
}
