a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.57beta8" a; 
  buildInputs = with a; [
    libX11 xproto gd SDL SDL_image SDL_mixer zlib libxml2
    pkgconfig
  ];

in
rec {
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/openlierox/openlierox/OpenLieroX%200.57%20Beta8/OpenLieroX_0.57_beta8.src.tar.bz2";
    sha256 = "1a3p03bi5v2mca7323mrckab9wsj83fjfcr6akrh9a6nlljcdn8d";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doInstall"];

  setParams = a.noDepEntry (''
    export SYSTEM_DATA_DIR="$out/share"
    export BIN_DIR="$out/bin"
    export DOC_DIR="$out/share/doc"
    export PIXMAP_DIR="$out/share/pixmap"

    export HAWKNL_BUILTIN=1
    export LIBZIP_BUILTIN=1
    export X11=1
    export DEBUG=1
  '');
  
  doBuild=a.fullDepEntry (''
    sed -re 's/ -1/ 255 /g' -i *.sh

    source functions.sh
    export INCLUDE_PATH=$(echo $NIX_CFLAGS_COMPILE | grep_param -I)
    
    bash compile.sh
  '') ["doUnpack" "addInputs" "setParams"];

  doInstall = a.fullDepEntry (''
    mkdir -p $BIN_DIR $SYSTEM_DATA_DIR $DOC_DIR $PIXMAP_DIR
    bash install.sh
  '') ["doBuild" "addInputs" "setParams" "defEnsureDir"];
      
  name = "openlierox-" + version;
  meta = {
    description = "Real-time game with Worms-like shooting";
    maintainers = [
    ];
  };
}
