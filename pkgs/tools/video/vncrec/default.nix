a :  
let 
  fetchurl = a.fetchurl;

  buildInputs = with a; [
    libX11 xproto imake gccmakedep libXt libXmu libXaw
    libXext xextproto libSM libICE libXpm libXp 
  ];
in
rec {
  src = fetchurl {
    url = "http://ronja.twibright.com/utils/vncrec-twibright.tgz";
    sha256 = "1yp6r55fqpdhc8cgrgh9i0mzxmkls16pgf8vfcpng1axr7cigyhc";
  };

  inherit buildInputs;
  makeFlags = [
    "World"
    ];
  installFlags=[
    "BINDIR=/bin/"
    "MANDIR=/share/man/man1"
    "DESTDIR=$out"
    "install.man"
    ];

  phaseNames = ["doXMKMF" "doMakeInstall"];

  doXMKMF = a.fullDepEntry (''
    xmkmf
  '') ["doUnpack" "minInit" "addInputs"];
      
  name = "vncrec";
  meta = {
    description = "VNC recorder";
    maintainers = [
    ];
  };
}
