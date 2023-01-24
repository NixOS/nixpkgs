{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "libsvm";
  version = "3.25";

  src = fetchurl {
    url = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/libsvm-${version}.tar.gz";
    sha256 = "sha256-UjUOiqdAsXbh13Pp3AjxNAIYw34BvsN6uQ2wEn5LteU=";
  };

  buildPhase = ''
    make
    make lib
  '';

  installPhase = let
    libSuff = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    install -D libsvm.so.2 $out/lib/libsvm.2${libSuff}
    ln -s $out/lib/libsvm.2${libSuff} $out/lib/libsvm${libSuff}
    install -Dt $out/bin/ svm-scale svm-train svm-predict
    install -Dm644 -t $out/include svm.h
    mkdir $out/include/libsvm
    ln -s $out/include/svm.h $out/include/libsvm/svm.h
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id libsvm.2.dylib $out/lib/libsvm.2.dylib;
  '';

  meta = with lib; {
    description = "A library for support vector machines";
    homepage = "https://www.csie.ntu.edu.tw/~cjlin/libsvm/";
    license = licenses.bsd3;
    maintainers = [ maintainers.spwhitt ];
    platforms = platforms.unix;
  };
}
