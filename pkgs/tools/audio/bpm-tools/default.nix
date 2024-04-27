{ stdenv
, lib
, fetchurl
, gnuplot
, sox
, flac
, id3v2
, vorbis-tools
, makeWrapper
}:

let
  path = lib.makeBinPath [ gnuplot sox flac id3v2 vorbis-tools ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "bpm-tools";
  version = "0.3";

  src = fetchurl {
    url = "http://www.pogo.org.uk/~mark/bpm-tools/releases/bpm-tools-${finalAttrs.version}.tar.gz";
    sha256 = "151vfbs8h3cibs7kbdps5pqrsxhpjv16y2iyfqbxzsclylgfivrp";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  postFixup = ''
    wrapProgram $out/bin/bpm-tag --prefix PATH : "${path}"
    wrapProgram $out/bin/bpm-graph --prefix PATH : "${path}"
  '';

  meta = with lib; {
    homepage = "http://www.pogo.org.uk/~mark/bpm-tools/";
    description = "Automatically calculate BPM (tempo) of music files";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ doronbehar ];
  };
})

