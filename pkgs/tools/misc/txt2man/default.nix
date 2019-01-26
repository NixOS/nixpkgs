{ stdenv, fetchurl, coreutils, gawk }:

stdenv.mkDerivation rec {
  name = "txt2man-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/mvertes/txt2man/archive/${name}.tar.gz";
    sha256 = "168cj96974n2z0igin6j1ic1m45zyic7nm5ark7frq8j78rrx4zn";
  };

  preConfigure = ''
    makeFlags=prefix="$out"
  '';

  patchPhase = ''
    for f in bookman src2man txt2man; do
        substituteInPlace $f --replace "gawk" "${gawk}/bin/gawk"

        substituteInPlace $f --replace "(date" "(${coreutils}/bin/date"
        substituteInPlace $f --replace "=cat" "=${coreutils}/bin/cat"
        substituteInPlace $f --replace "cat <<" "${coreutils}/bin/cat <<"
        substituteInPlace $f --replace "expand" "${coreutils}/bin/expand"
        substituteInPlace $f --replace "(uname" "(${coreutils}/bin/uname"
    done
  '';

  doCheck = true;

  checkPhase = ''
    # gawk and coreutils are part of stdenv but will not
    # necessarily be in PATH at runtime.
    sh -c 'unset PATH; printf hello | ./txt2man'
  '';

  meta = {
    description = "Convert flat ASCII text to man page format";
    homepage = http://mvertes.free.fr/;
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
