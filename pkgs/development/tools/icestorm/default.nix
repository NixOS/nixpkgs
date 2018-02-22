{ stdenv, fetchFromGitHub, python3, libftdi, pkgconfig }:

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2018.02.14";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "edbf5fce90ff0e71922a54241a1aec914cc3e230";
    sha256 = "01d6xv5c4x8w8lamc8n3vnqsyn7ykhh1ws7k96d6ij5fs52k94xb";
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
