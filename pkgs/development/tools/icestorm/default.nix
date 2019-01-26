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
  version = "2018.12.31";

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "c0cbae88ab47a3879aacf80d53b6a85710682a6b";
    sha256 = "0bqm0rpywm64yvbq75klpyzb1g9sdsp1kvdlyqg4hvm8jw9w8lya";
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
