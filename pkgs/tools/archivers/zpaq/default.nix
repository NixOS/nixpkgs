{ stdenv, fetchurl, perl, unzip }:
stdenv.mkDerivation rec {
  name = "zpaq-${version}";
  version = "715";

  src = let
    mungedVersion = with stdenv.lib; concatStrings (splitString "." version);
  in fetchurl {
    sha256 = "066l94yyladlfzri877nh2dhkvspagjn3m5bmv725fmhkr9c4pp8";
    url = "http://mattmahoney.net/dc/zpaq${mungedVersion}.zip";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ perl /* for pod2man */ ];
  buildInputs = [ unzip ];

  preBuild = let
    CPPFLAGS = with stdenv; ""
      + (lib.optionalString (!isi686 && !isx86_64) "-DNOJIT ")
      + "-Dunix";
    CXXFLAGS = "-O3 -DNDEBUG";
  in ''
    buildFlagsArray=( "CPPFLAGS=${CPPFLAGS}" "CXXFLAGS=${CXXFLAGS}" )
  '';

  enableParallelBuilding = true;

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Incremental journaling backup utility and archiver";
    homepage = http://mattmahoney.net/dc/zpaq.html;
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    inherit version;
  };
}
