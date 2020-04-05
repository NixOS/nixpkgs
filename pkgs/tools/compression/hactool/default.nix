{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "hactool";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "SciresM";
    repo = pname;
    rev = version;
    sha256 = "19sn91xm72sl05rj918vihm1g8a7bp03mw397japiq3x6jfd6n14";
  };

  preBuild = ''
    mv config.mk.template config.mk
  '';

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    mv hactool $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/SciresM/hactool";
    description = "A tool to view information about, decrypt, and extract common file formats for the Nintendo Switch";
    license = licenses.isc;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.linux;
  };
}
