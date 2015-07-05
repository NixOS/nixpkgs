{stdenv, fetchgit}:

stdenv.mkDerivation rec {
  name = "Albatross-${version}";
  version = "1.7.3";

  src = fetchgit {
    url = git://github.com/shimmerproject/Albatross.git;
    rev = "refs/tags/v${version}";
    sha256 = "7a585068dd59f753149c0d390f2ef541f2ace67e7d681613588edb9f962e3196";
  };

  dontBuild = true;

  installPhase = ''
    install -dm 755 $out/share/themes/Albatross
    cp -dr --no-preserve='ownership' {LICENSE.GPL,README,index.theme,gtk-2.0,gtk-3.0,metacity-1,xfwm4} $out/share/themes/Albatross/
  '';

  meta = {
    description = "Albatross";
    homepage = "http://shimmerproject.org/our-projects/albatross/";
    license = stdenv.lib.licenses.gpl2;
  };
}
