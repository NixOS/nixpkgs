{ stdenv, fetchurl, unzip, fpc, lazarus }:

let
  date = "07.apr.2016";

in stdenv.mkDerivation rec {
  name = "mht2mht-${version}";
  version = "1.8.1.35";

  src = fetchurl {
    # there is a disconnect between the directory name date and file name date
    # you should verify if that is still then case when the next version is released
    url    = "mirror://sourceforge/mht2htm/mht2htm/1.8.1%20%2805.apr.2016%29/mht2htmcl-${version}_${date}.source.zip";
    sha256 = "16r6zkihp84yqllp2hyaf0nvymdn9ji3g30mc5scfwycdfanja6f";
  };

  sourceRoot = ".";

  buildInputs = [ fpc lazarus ];

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
    runHook preBuild
    lazbuild --lazarusdir=${lazarus}/share/lazarus mht2htmcl.lpi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin               mht2htmcl
    install -Dm644 -t $out/share/doc/mht2htm CHANGELOG COPYING README
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Convert .mht files to .html";
    homepage    = http://pgm.bpalanka.com/mht2htm.html;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.all;
  };
}
