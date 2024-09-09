{ lib, stdenv, fetchFromGitHub, lua5_3, python3 }:

stdenv.mkDerivation rec {
  pname = "bam";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "matricks";
    repo = "bam";
    rev = "v${version}";
    sha256 = "13br735ig7lygvzyfd15fc2rdygrqm503j6xj5xkrl1r7w2wipq6";
  };

  nativeBuildInputs = [ lua5_3 python3 ];

  buildPhase = "${stdenv.shell} make_unix.sh";

  checkPhase = "${python3.interpreter} scripts/test.py";

  strictDeps = true;

  installPhase = ''
    mkdir -p "$out/share/bam"
    cp -r docs examples tests  "$out/share/bam"
    mkdir -p "$out/bin"
    cp bam "$out/bin"
  '';

  meta = with lib; {
    description = "Yet another build manager";
    mainProgram = "bam";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.zlib;
    downloadPage = "http://matricks.github.com/bam/";
  };
}
