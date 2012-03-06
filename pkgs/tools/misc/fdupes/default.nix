{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "fdupes-1.50-PR2";
  src = fetchurl {
    url = http://fdupes.googlecode.com/files/fdupes-1.50-PR2.tar.gz;
    sha256 = "068nxcn3xilaphq53sywli9ndydy4gijfi2mz7h45kpy0q9cgwjs";
  };

  # workaround: otherwise make install fails (should be fixed in trunk)
  preInstall = "mkdir -p $out/bin $out/man/man1";

  makeFlags = "PREFIX=\${out}";

  meta = {
    description = "identifies duplicate files residing within specified directories.";
    longDescription = ''
      FDUPES uses md5sums and then a byte by byte comparison to finde duplicate
      files within a set of directories.
    '';
    homepage = http://code.google.com/p/fdupes/;
    license = "MIT";
    platforms = stdenv.lib.platforms.all;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
