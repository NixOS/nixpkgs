{ stdenv, fetchurl, yacc }:

stdenv.mkDerivation rec {
  name = "jam-2.6";

  src = fetchurl {
    url = "https://swarm.workshop.perforce.com/projects/perforce_software-jam/download/main/${name}.tar";
    sha256 = "0j4r7xcjz15ksnnpjw56qi99q4lpjmx097pkwwkl1hq3hqml1zhn";
  };

  nativeBuildInputs = [ yacc ];

  buildPhase = ''
    make jam0
    ./jam0 -j$NIX_BUILD_CORES -sBINDIR=$out/bin install
  '';

  installPhase = ''
    mkdir -p $out/doc/jam
    cp *.html $out/doc/jam
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.perforce.com/resources/documentation/jam;
    license = licenses.free;
    description = "Just Another Make";
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.unix;
  };
}
