{ stdenv, fetchFromGitHub, lua5_3, python }:

stdenv.mkDerivation rec {
  name = "bam-${version}";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "matricks";
    repo = "bam";
    rev = "v${version}";
    sha256 = "13br735ig7lygvzyfd15fc2rdygrqm503j6xj5xkrl1r7w2wipq6";
  };

  buildInputs = [ lua5_3 python ];

  buildPhase = ''${stdenv.shell} make_unix.sh'';

  checkPhase = ''${python.interpreter} scripts/test.py'';

  installPhase = ''
    mkdir -p "$out/share/bam"
    cp -r docs examples tests  "$out/share/bam"
    mkdir -p "$out/bin"
    cp bam "$out/bin"
  '';

  meta = with stdenv.lib; {
    description = "Yet another build manager";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.zlib;
    downloadPage = "http://matricks.github.com/bam/";
  };
}
