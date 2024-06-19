{ lib, mkDerivation, fetchFromBitbucket, docutils, bison, flex, qmake
, qtbase
}:

mkDerivation rec {
  pname = "xxdiff";
  version = "5.0b1";

  src = fetchFromBitbucket {
    owner = "blais";
    repo = pname;
    rev = "5e5f885dfc43559549a81c59e9e8c9525306356a";
    sha256 = "0gbvxrkwkbvag3298j89smszghpr8ilxxfb0cvsknfqdf15b296w";
  };

  nativeBuildInputs = [ bison docutils flex qmake ];

  buildInputs = [ qtbase ];

  dontUseQmakeConfigure = true;

  # c++11 and above is needed for building with Qt 5.9+
  env.NIX_CFLAGS_COMPILE = toString [ "-std=c++14" ];

  sourceRoot = "${src.name}/src";

  postPatch = ''
    substituteInPlace xxdiff.pro --replace ../bin ./bin
  '';

  preConfigure = ''
    make -f Makefile.bootstrap
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin                ./bin/xxdiff
    install -Dm444 -t $out/share/doc/${pname} ${src}/README

    runHook postInstall
  '';

  meta = with lib; {
    description = "Graphical file and directories comparator and merge tool";
    mainProgram = "xxdiff";
    homepage = "http://furius.ca/xxdiff/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub raskin ];
    platforms = platforms.linux;
  };
}
