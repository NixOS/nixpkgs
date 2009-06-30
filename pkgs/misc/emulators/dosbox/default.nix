{stdenv, fetchurl, SDL, makeDesktopItem}:

stdenv.mkDerivation rec { 
  name = "dosbox-0.73";
  
  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "b0a94c46164391a9c32d9571e4d0b61ff238908ff0b77e09157c22dc98a93765";
  };
  
  buildInputs = [SDL];    
    
  desktopItem = makeDesktopItem {
    name = "dosbox";
    exec = "dosbox";
    comment = "x86 emulator with internal DOS";
    desktopName = "DOSBox";
    genericName = "DOS emulator";
    categories = "Application;Emulator;";
  };

  postInstall = ''
     ensureDir $out/share/applications
     cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
  };
}
