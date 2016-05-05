{ stdenv, fetchurl, perl, unzip }:
stdenv.mkDerivation rec {
  name = "zpaq-${version}";
  version = "7.12";

  src = let
    mungedVersion = with stdenv.lib; concatStrings (splitString "." version);
  in fetchurl {
    sha256 = "1lgkxiinam80pqqyvs3x845k6kf0wgw121vz0gr8za4blb756n30";
    url = "http://mattmahoney.net/dc/zpaq${mungedVersion}.zip";
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
    description = "Incremental journaling backup utility and archiver";
    homepage = http://mattmahoney.net/dc/zpaq.html;
    license = licenses.gpl3Plus ;
    maintainers = with maintainers; [ raskin nckx ];
    platforms = platforms.linux;
  };
}
