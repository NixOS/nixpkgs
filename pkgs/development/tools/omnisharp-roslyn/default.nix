{ stdenv
, fetchurl
, mono5
, makeWrapper
}:

stdenv.mkDerivation rec {

  pname = "omnisharp-roslyn";
  version = "1.35.1";

  src = fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-mono.tar.gz";
    sha256 = "0gx87qc9r3lhqn6q95y74z67sjcxnazkkdi9zswmaqyvjn8x7vf4";
  };

  nativeBuildInputs = [ makeWrapper ];

  preUnpack = ''
    mkdir src
    cd src
    sourceRoot=.
  '';

  installPhase = ''
    mkdir -p $out/bin
    cd ..
		cp -r src $out/
    ls -al $out/src
    makeWrapper ${mono5}/bin/mono $out/bin/omnisharp \
    --add-flags "$out/src/OmniSharp.exe"
  '';

  meta = with stdenv.lib; {
    description = "OmniSharp based on roslyn workspaces";
    homepage = "https://github.com/OmniSharp/omnisharp-roslyn";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ tesq0 ];
  };

}
