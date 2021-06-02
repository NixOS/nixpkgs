{ lib, stdenv, fetchFromGitHub, coreutils, gawk }:

stdenv.mkDerivation rec {
  pname = "txt2man";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "mvertes";
    repo = "txt2man";
    rev = "${pname}-${version}";
    sha256 = "Aqi5PNNaaM/tr9A/7vKeafYKYIs/kHbwHzE7+R/9r9s=";
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
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
