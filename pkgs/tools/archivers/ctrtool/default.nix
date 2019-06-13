{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ctrtool";
  version = "0.15";

  src = fetchFromGitHub {
    owner  = "profi200";
    repo   = "Project_CTR";
    rev    = version;
    sha256 = "1l6z05x18s1crvb283yvynlwsrpa1pdx1nbijp99plw06p88h4va";
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
