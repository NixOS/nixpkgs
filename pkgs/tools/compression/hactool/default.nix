{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "hactool";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "SciresM";
    repo = "hactool";
    rev = "1.3.3";
    sha256 = "1qb51fck7liqc1ridms8wdlzgbdbvp6iv4an8jvmzhcj5p5xq631";
  };

  preBuild = ''
    mv config.mk.template config.mk
  '';

  installPhase = ''
    install -D hactool $out/bin/hactool
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/SciresM/hactool";
    description = "A tool to manipulate common file formats for the Nintendo Switch";
    longDescription = "A tool to view information about, decrypt, and extract common file formats for the Nintendo Switch, especially Nintendo Content Archives";
    license = licenses.isc;
    maintainers = with maintainers; [ ivar ];
    platforms = platforms.unix;
  };
}
