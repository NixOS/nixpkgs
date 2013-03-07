{ stdenv, fetchurl, coreutils ? null }:

stdenv.mkDerivation {
  name = "diffutils-3.2";

  src = fetchurl {
    url = mirror://gnu/diffutils/diffutils-3.2.tar.gz;
    sha256 = "1lsf0ln0h3mnm2y0mwgrfk0lyfi7bnm4r886acvdrrsvc7pypaia";
  };

  patches = [ ./gets-undeclared.patch ];

  /* If no explicit coreutils is given, use the one from stdenv. */
  nativeBuildInputs = [ coreutils ];

  meta = {
    homepage = http://www.gnu.org/software/diffutils/diffutils.html;
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
  };
}
