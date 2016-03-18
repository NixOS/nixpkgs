{ stdenv, fetchurl, perl, unzip }:
let
  s = # Generated upstream information
  rec {
    baseName="zpaq";
    version="706";
    name="${baseName}-${version}";
    hash="0wn5hs02aac61rjbba3s6wibyk73f1mfcbqnf34hcpyj2gl5i59k";
    url="http://mattmahoney.net/dc/zpaq706.zip";
    sha256="0wn5hs02aac61rjbba3s6wibyk73f1mfcbqnf34hcpyj2gl5i59k";
  };
in
stdenv.mkDerivation {
  inherit (s) name version;

  src = fetchurl {
    inherit (s) url sha256;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ perl /* for pod2man */ ];
  buildInputs = [ unzip ];

  preBuild = let
    CPPFLAGS = with stdenv; ""
      + (lib.optionalString (!isi686 && !isx86_64) "-DNOJIT ")
      + "-Dunix";
    CXXFLAGS = with stdenv; ""
      + (lib.optionalString (isi686) "-march=i686 ")
      + (lib.optionalString (isx86_64) "-march=nocona ")
      + "-O3 -mtune=generic -DNDEBUG";
  in ''
    buildFlagsArray=( "CPPFLAGS=${CPPFLAGS}" "CXXFLAGS=${CXXFLAGS}" )
  '';

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    inherit (s) version;
    description = "Incremental journaling backup utility and archiver";
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin nckx ];
    platforms = platforms.linux;
    homepage = "http://mattmahoney.net/dc/zpaq.html";
  };
}
