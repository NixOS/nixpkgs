{ stdenv, fetchFromGitHub, gcc, jdk, which }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "drip";
  version = "0.2.4";

  src = fetchFromGitHub {
    repo = pname;
    owner = "flatland";
    rev = version;
    sha256 = "1zl62wdwfak6z725asq5lcqb506la1aavj7ag78lvp155wyh8aq1";
   #fetchSubmodules = true;
  };

  buildInputs = [ gcc jdk which ];
 
  patchPhase = ''
    mkdir $out
    cp ./* $out -r
  '';

  buildPhase = ''
    $out/bin/drip version
  '';

  phases = [ "unpackPhase" "patchPhase" "buildPhase" ];

  meta = with stdenv.lib; {
    description = "a launcher for the Java Virtual Machine intended to be a drop-in replacement for the java command, only faster";
    license = licenses.epl;
    homepage = https://github.com/flatland/drip;
    platforms = platforms.linux;
    maintainers = [ maintainers.rybern ];
  };
}
