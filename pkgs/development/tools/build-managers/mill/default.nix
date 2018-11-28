{ stdenv, fetchurl, jre }:
stdenv.mkDerivation rec {
  name = "mill-${version}";
  version = "0.3.5";

  src = fetchurl {
    url = "https://github.com/lihaoyi/mill/releases/download/${version}/${version}";
    sha256 = "19ka81f6vjr85gd8cadn0fv0i0qcdspx2skslfksklxdxs2gasf8";
  };

  propagatedBuildInputs = [ jre ] ;

  unpackPhase = ''
    echo "Skipping unpackphase, nothing to unpack"
  '';

  dontConfigure = true;
  
  dontBuild = true;
    
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ${src} $out/bin/mill
    chmod +x $out/bin/mill
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://www.lihaoyi.com/mill;
    license = licenses.mit;
    description = "A build tool for Scala, Java and more";
    maintainers = with maintainers; [ scalavision ];
    platforms = platforms.unix;
  };

}
