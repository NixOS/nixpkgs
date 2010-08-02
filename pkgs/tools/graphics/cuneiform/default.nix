a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "1.0" a; 
  buildInputs = with a; [
    cmake imagemagick patchelf
  ];
in
rec {
  src = fetchurl {
    url = "http://launchpad.net/cuneiform-linux/${version}/${version}/+download/cuneiform-linux-${version}.0.tar.bz2";
    sha256 = "bfa7acc6aade966ab62bc0f19e0ac1a843b659a70202229570c087ca8b15f39e";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMakeInstall" "postInstall"];

  libc = if a.stdenv ? glibc then a.stdenv.glibc else "";

  doCmake = a.fullDepEntry(''
    ensureDir $PWD/builddir
    cd builddir
    export NIX_LDFLAGS="$NIX_LDFLAGS -ldl -L$out/lib"
    cmake .. -DCMAKE_BUILD_TYPE=debug -DCMAKE_INSTALL_PREFIX=$out -DDL_LIB=${libc}/lib
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
      
  postInstall = a.fullDepEntry(''
    patchelf --set-rpath $out/lib${if a.stdenv.gcc.gcc != null then ":${a.stdenv.gcc.gcc}/lib" else ""}:${a.imagemagick}/lib $out/bin/cuneiform
  '') ["minInit" "addInputs" "doMakeInstall"];

  name = "cuneiform-" + version;
  meta = {
    description = "Cuneiform OCR";
  };
}
