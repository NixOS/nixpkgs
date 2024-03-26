{ stdenv, lib, perlPackages, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "tes3cmd";
  version = "0.40-pre-release-2";

  src = fetchFromGitHub {
    owner = "john-moonsugar";
    repo = pname;
    rev = "f72e9ed9dd18e8545dd0dc2a4056c250cf505790";
    sha256 = "01zqplp8yb0xnl54963n0zkz66rf3hn2x3i255jlhdhx1c43jba7";
  };

  buildInputs = [ perlPackages.perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp tes3cmd $out/bin/tes3cmd
  '';

  meta = with lib; {
    description = "A command line tool for examining and modifying plugins for the Elder Scrolls game Morrowind by Bethesda Softworks";
    mainProgram = "tes3cmd";
    homepage = "https://github.com/john-moonsugar/tes3cmd";
    license = licenses.mit;
    maintainers = [ maintainers.marius851000 ];
    platforms = platforms.linux;
  };
}
