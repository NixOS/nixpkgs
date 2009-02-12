a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "0.6" a; 
  buildInputs = with a; [
    cmake imagemagick patchelf
  ];
in
rec {
  src = fetchurl {
    url = "http://launchpad.net/cuneiform-linux/${version}/${version}/+download/cuneiform-${version}.tar.bz2";
    sha256 = "0jgiccimwv1aqp9gzl9937gdlh9zl5qpaygf0n1xcbfd5aqz14ig";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMakeInstall" "postInstall"];

  libc = if a.stdenv ? glibc then a.stdenv.glibc else "";

  doCmake = a.FullDepEntry(''
    ensureDir $PWD/builddir
    cd builddir
    export NIX_LDFLAGS="$NIX_LDFLAGS -ldl -L$out/lib"
    cmake .. -DCMAKE_BUILD_TYPE=debug -DCMAKE_INSTALL_PREFIX=$out -DDL_LIB=${libc}/lib
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
      
  postInstall = a.FullDepEntry(''
    patchelf --set-rpath $out/lib${if a.stdenv.gcc.gcc != null then ":${a.stdenv.gcc.gcc}/lib" else ""} $out/bin/cuneiform
  '') ["minInit" "addInputs" "doMakeInstall"];

  name = "cuneiform-" + version;
  meta = {
    description = "Cuneiform OCR";
  };
}
