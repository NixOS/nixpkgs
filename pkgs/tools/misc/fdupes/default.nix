{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "fdupes-20150902";

  src = fetchFromGitHub {
    owner = "jbruchon";
    repo  = "fdupes-jody";
    rev   = "414b1fd64c0a739d4c52228eb72487782855b939";
    sha256 = "1q6jcj79pljm1f24fqgk8x53xz2x0p1986znw75iljxqyzbvw0ap";
  };

  makeFlags = "PREFIX=\${out}";

  meta = {
    description = "Identifies duplicate files residing within specified directories";
    longDescription = ''
      FDUPES compares inodes' stats, hash sums, and byte by byte file
      contents to find duplicate files within a set of directories and
      then applies various actions to those sets, e.g.:
      * remove some of the duplicates,
      * turn all the files in a set into hardlinks.
    '';
    homepage = src.meta.homepage;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
