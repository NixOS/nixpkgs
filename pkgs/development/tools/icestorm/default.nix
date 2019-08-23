{ stdenv, fetchFromGitHub
, pkgconfig, libftdi
, python3, pypy3

# PyPy yields large improvements in build time and runtime performance,
# and IceStorm isn't intended to be used as a library other than by the
# nextpnr build process (which is also sped up by using PyPy), so we
# use it by default. See 18839e1 for more details.
, usePyPy ? stdenv.hostPlatform.system == "x86_64-linux"
}:

stdenv.mkDerivation rec {
  pname = "icestorm";
  version = "2019.08.15";

  pythonPkg = if usePyPy then pypy3 else python3;
  pythonInterp = pythonPkg.interpreter;

  src = fetchFromGitHub {
    owner  = "cliffordwolf";
    repo   = "icestorm";
    rev    = "95949315364f8d9b0c693386aefadf44b28e2cf6";
    sha256 = "05q1vxlf9l5z9mam8jbv58jqj7nsd8v7ssy753sharpgzzgdc8a2";
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
    maintainers = with stdenv.lib.maintainers; [ shell thoughtpolice emily ];
    platforms   = stdenv.lib.platforms.all;
  };
}
