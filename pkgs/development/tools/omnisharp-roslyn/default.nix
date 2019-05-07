{ stdenv
, fetchurl
, mono5
, makeWrapper
}:

stdenv.mkDerivation rec {

  name = "omnisharp-roslyn-${version}";
  version = "1.32.8";
  
  src = fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-mono.tar.gz";
    sha256 = "0k2a4awmzb7ppll2skyzaa94n3hxqm35ffibl0sygldk3symzwgp";
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
