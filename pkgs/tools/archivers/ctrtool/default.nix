{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ctrtool";
  version = "0.16";

  src = fetchFromGitHub {
    owner  = "jakcron";
    repo   = "Project_CTR";
    rev    = "v${version}";
    sha256 = "1n3j3fd1bqd39v5bdl9mhq4qdrcl1k4ib1yzl3qfckaz3y8bkrap";
  };

  sourceRoot = "source/ctrtool";

  enableParallelBuilding = true;

  installPhase = "
    mkdir $out/bin -p
    cp ctrtool $out/bin/ctrtool
  ";

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "A tool to extract data from a 3ds rom";
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
  };

}
