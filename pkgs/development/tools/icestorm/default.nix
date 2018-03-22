{ stdenv, fetchFromGitHub, python3, libftdi, pkgconfig }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2018.03.21";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "4476d83f76fa0222be0b691fe27c1e0228266f82";
    sha256 = "1r43vwwz61rvdpc3kylg8yzv0flz9p4j3yc1cc4h904zsdwjx39a";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python3 libftdi ];
  makeFlags = [ "PREFIX=$(out)" ];

  # fix icebox_vlog chipdb path. icestorm issue:
  #   https://github.com/cliffordwolf/icestorm/issues/125
  patchPhase = ''
    substituteInPlace ./icebox/icebox_vlog.py \
      --replace /usr/local/share "$out/share"
  '';

  meta = {
    description = "Documentation and tools for Lattice iCE40 FPGAs";
    longDescription = ''
      Project IceStorm aims at reverse engineering and
      documenting the bitstream format of Lattice iCE40
      FPGAs and providing simple tools for analyzing and
      creating bitstream files.
    '';
    homepage = http://www.clifford.at/icestorm/;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms = stdenv.lib.platforms.linux;
  };
}
