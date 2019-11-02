{
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "bpm-tools";
  version = "0.3";

  src = fetchurl {
    url = "http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-${version}.tar.gz";
    sha256 = "151vfbs8h3cibs7kbdps5pqrsxhpjv16y2iyfqbxzsclylgfivrp";
  };

  patchPhase = ''
    patchShebangs bpm-tag
    patchShebangs bpm-graph
  '';

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.pogo.org.uk/~mark/bpm-tools/";
    description = "Automatically calculate BPM (tempo) of music files";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ doronbehar ];
  };
}

