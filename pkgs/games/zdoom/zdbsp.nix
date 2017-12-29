{ stdenv, fetchurl, cmake, unzip, zlib }:

stdenv.mkDerivation rec {
  name = "zdbsp-${version}";
  version = "1.19";

  src = fetchurl {
    url = "https://zdoom.org/files/utils/zdbsp/zdbsp-${version}-src.zip";
    sha256 = "0j82q7g7hgvnahk6gdyhmn9880mqii3b4agqc98f5xaj3kxmd2dr";
  };

  nativeBuildInputs = [cmake unzip];
  buildInputs = [zlib];
  sourceRoot = ".";
  enableParallelBuilding = true;
  installPhase = ''
    install -Dm755 zdbsp $out/bin/zdbsp
  '';

  meta = with stdenv.lib; {
    description = "ZDoom's internal node builder for DOOM maps";
    homepage = https://zdoom.org/wiki/ZDBSP;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ertes];
    platforms = platforms.linux;
  };
}
