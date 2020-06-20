{ stdenv, fetchurl, coreutils, gawk }:

stdenv.mkDerivation rec {
  pname = "txt2man";
  version = "1.7.0";

  src = fetchurl {
    url = "https://github.com/mvertes/txt2man/archive/${pname}-${version}.tar.gz";
    sha256 = "06jf8hqav095db1v3njavx0rphmpmi3mgki4va6qkxjnvmdx4742";
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
    homepage = "http://mvertes.free.fr/";
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
