{ stdenv, fetchzip, makeWrapper, jre}:

stdenv.mkDerivation rec {
  pname = "kotlin-language-server";
  version = "0.7.0";

  src = fetchzip {
    url = "https://github.com/fwcd/kotlin-language-server/releases/download/${version}/server.zip";
    sha256 = "1nsfird6mxzi2cx6k2dlvlsn3ipdf4l1grd4iwz42y3ihm8drgpa";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D $src/bin/kotlin-language-server -t $out/bin
    cp -r $src/lib $out/lib

    wrapProgram $out/bin/kotlin-language-server \
      --prefix PATH : ${jre}/bin
  '';

  meta = with stdenv.lib; {
    description = "Intelligent Kotlin support for any editor/IDE using the Language Server Protocol";
    homepage = "https://github.com/fwcd/kotlin-language-server";
    maintainers = with maintainers; [ enderger ];
    license = licenses.mit;
  };
}
