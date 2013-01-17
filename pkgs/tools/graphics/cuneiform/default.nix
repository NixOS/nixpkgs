a :  
let 
  fetchurl = a.fetchurl;

  version = "1.1.0";
  buildInputs = with a; [
    cmake imagemagick patchelf
  ];
in
rec {
  src = fetchurl {
    url = "https://launchpad.net/cuneiform-linux/1.1/1.1/+download/cuneiform-linux-1.1.0.tar.bz2";
    sha256 = "1bdvppyfx2184zmzcylskd87cxv56d8f32jf7g1qc8779l2hszjp";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doCmake" "doMakeInstall" "postInstall"];

  libc = if a.stdenv ? glibc then a.stdenv.glibc else "";

  doCmake = a.fullDepEntry(''
    mkdir -p $PWD/builddir
    cd builddir
    export NIX_LDFLAGS="$NIX_LDFLAGS -ldl -L$out/lib"
    cmake .. -DCMAKE_BUILD_TYPE=debug -DCMAKE_INSTALL_PREFIX=$out -DDL_LIB=${libc}/lib
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
      
  needLib64 = a.stdenv.system == "x86_64-linux";

  postInstall = a.fullDepEntry(''
    patchelf --set-rpath $out/lib${if needLib64 then "64" else ""}${if a.stdenv.gcc.gcc != null then ":${a.stdenv.gcc.gcc}/lib" else ""}${if a.stdenv.gcc.gcc != null && needLib64 then ":${a.stdenv.gcc.gcc}/lib64" else ""}:${a.imagemagick}/lib $out/bin/cuneiform
  '') ["minInit" "addInputs" "doMakeInstall"];

  name = "cuneiform-" + version;
  meta = {
    description = "Cuneiform OCR";
  };
}
