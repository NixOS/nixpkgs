{stdenv, fetchurl, coreutils ? null}:

stdenv.mkDerivation {
  name = "diffutils-3.0";
  
  src = fetchurl {
    url = mirror://gnu/diffutils/diffutils-3.0.tar.gz;
    sha256 = "02g8i6jv0j0vr5nl13ns50lv2dbjy9kkk8jvp11n0g5fpdjizf9g";
  };
  
  /* If no explicit coreutils is given, use the one from stdenv. */
  buildNativeInputs = [coreutils];

  meta = {
    homepage = http://www.gnu.org/software/diffutils/diffutils.html;
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
  };
}
