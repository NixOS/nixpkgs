{ stdenv
, fetchurl
, mono5
, makeWrapper
}:

stdenv.mkDerivation rec {

  pname = "omnisharp-roslyn";
  version = "1.35.0";
  
  src = fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-mono.tar.gz";
    sha256 = "191jiyw6kx1rw241bg9nv5splfpz6ny90g9yf28cd0xwpx978p83";
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
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ tesq0 ];
  };

}
