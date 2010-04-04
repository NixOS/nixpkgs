{stdenv, fetchurl, coreutils ? null}:

stdenv.mkDerivation {
  name = "diffutils-2.8.1";
  
  src = fetchurl {
    url = mirror://gnu/diffutils/diffutils-2.8.1.tar.gz;
    md5 = "71f9c5ae19b60608f6c7f162da86a428";
  };
  
  /* If no explicit coreutils is given, use the one from stdenv. */
  buildNativeInputs = [coreutils];

  meta = {
    homepage = http://www.gnu.org/software/diffutils/diffutils.html;
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
  };
}
