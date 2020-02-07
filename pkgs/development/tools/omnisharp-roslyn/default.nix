{ stdenv
, fetchurl
, mono5
, makeWrapper
}:

stdenv.mkDerivation rec {

  pname = "omnisharp-roslyn";
  version = "1.34.11";
  
  src = fetchurl {
    url = "https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${version}/omnisharp-mono.tar.gz";
    sha256 = "0j55jrji7ya0pm91hfmyd9s6lkl35xbybr81a1gka90mlyp0gx63";
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
