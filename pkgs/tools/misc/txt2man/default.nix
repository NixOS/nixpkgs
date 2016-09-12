{ stdenv, fetchurl, coreutils, gawk }:

stdenv.mkDerivation rec {
  name = "txt2man-1.5.6";

  src = fetchurl {
    url = "http://mvertes.free.fr/download/${name}.tar.gz";
    sha256 = "0ammlb4pwc4ya1kc9791vjl830074zrpfcmzc18lkcqczp2jaj4q";
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
