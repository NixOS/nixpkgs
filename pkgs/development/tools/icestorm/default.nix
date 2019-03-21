{ stdenv, fetchFromGitHub
, pkgconfig, libftdi
, python3, pypy3
}:

let
  pypyCompatible = stdenv.isx86_64; /* pypy3 seems broken on i686 */
  pythonPkg      = if pypyCompatible then pypy3 else python3;
  pythonInterp   = pythonPkg.interpreter;
in

stdenv.mkDerivation rec {
  name = "icestorm-${version}";
  version = "2019.02.23";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "3a2bfee5cbc0558641668114260d3f644d6b7c83";
    sha256 = "1avc9b6w3xbmpq4y4lf9b5mym6aygh5hngzyasa9jyj0cx8mxcpf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pythonPkg libftdi ];
  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  # fix icebox_vlog chipdb path. icestorm issue:
  #   https://github.com/cliffordwolf/icestorm/issues/125
  #
  # also, fix up the path to the chosen Python interpreter. for pypy-compatible
  # platforms, it offers significant performance improvements.
  patchPhase = ''
    substituteInPlace ./icebox/icebox_vlog.py \
      --replace /usr/local/share "$out/share"

    for x in icefuzz/Makefile icebox/Makefile icetime/Makefile; do
      substituteInPlace "$x" --replace python3 "${pythonInterp}"
    done

    for x in $(find . -type f -iname '*.py'); do
      substituteInPlace "$x" \
        --replace '/usr/bin/env python3' '${pythonInterp}'
    done
  '';

  meta = {
    description = "Documentation and tools for Lattice iCE40 FPGAs";
    longDescription = ''
      Project IceStorm aims at reverse engineering and
      documenting the bitstream format of Lattice iCE40
      FPGAs and providing simple tools for analyzing and
      creating bitstream files.
    '';
    homepage    = http://www.clifford.at/icestorm/;
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
