{ stdenv, fetchFromGitHub, perl, unzip }:

stdenv.mkDerivation rec {
  pname = "zpaq";
  version = "7.15";

  src = fetchFromGitHub {
    owner = "zpaq";
    repo = "zpaq";
    rev = version;
    sha256 = "0v44rlg9gvwc4ggr2lhcqll8ppal3dk7zsg5bqwcc5lg3ynk2pz4";
  };

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
