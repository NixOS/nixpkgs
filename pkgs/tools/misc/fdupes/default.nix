{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fdupes-1.51";
  src = fetchurl {
    url = https://github.com/adrianlopezroche/fdupes/archive/fdupes-1.51.tar.gz;
    sha256 = "11j96vxl9vg3jsnxqxskrv3gad6dh7hz2zpyc8n31xzyxka1c7kn";
  };

  # workaround: otherwise make install fails (should be fixed in trunk)
  preInstall = "mkdir -p $out/bin $out/man/man1";

  makeFlags = "PREFIX=\${out}";

  meta = {
    description = "Identifies duplicate files residing within specified directories";
    longDescription = ''
      FDUPES uses md5sums and then a byte by byte comparison to finde duplicate
      files within a set of directories.
    '';
    homepage = http://code.google.com/p/fdupes/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
