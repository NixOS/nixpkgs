{ fetchurl, lib, stdenv }:

stdenv.mkDerivation ({
  version = "3.8";
  pname = "tet";

  src = fetchurl {
    url = "http://tetworks.opengroup.org/downloads/38/software/Sources/3.8/tet3.8-src.tar.gz";
    sha256 = "1j57hv56df38w249l595b8rsgmsyvjkbysai03a9724gax5jl9av" ;
  };

  buildInputs = [ ];

  patchPhase = "chmod +x configure";

  configurePhase = "./configure -t lite";

  buildPhase = "cd src; make; cd -";

  installPhase = "cd src; make install; cd -; cp -vr $PWD $out";

  meta = {
    description = "The Test Environment Toolkit is used in test applications like The Open Group's UNIX Certification program and the Free Standards Group's LSB Certification program";
    homepage = "http://tetworks.opengroup.org/Products/tet.htm";
    license = lib.licenses.artistic1;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
