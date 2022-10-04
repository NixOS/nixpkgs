{ lib, stdenv, fetchgit, fortune }:

stdenv.mkDerivation rec {
  pname = "blag-fortune";
  version = "2022-07-16";

  # We use fetchurl instead of fetchFromGitHub because the release pack has some
  # special files.
  src = fetchgit {
    url = "https://notabug.org/PangolinTurtle/BLAG-fortune.git";
    rev = "b07fb0312f";
    sha256 = "sha256-Fi8o+hd2frBXXfzjwiJC7/2ZjdEc8vJbB7bSh9n3Vx0=";
  };

  # NOTE: this is needed for strfile in installPhase
  buildInputs = [ fortune ];

  installPhase = ''
  cat people/* anarchism
  strfile anarchism
  install -D -t $out/share/fortunes anarchism
  install -D -t $out/share/fortunes anarchism.dat
  '';


  meta = with lib; {
    mainProgram = "blag-fortune";
    description = "Ongoing project to have English language political fortunes in BLAG";
    homepage = "https://notabug.org/PangolinTurtle/BLAG-fortune";
    license = licenses.publicDomain;
    platforms = platforms.all;
    maintainers = with maintainers; [ cafkafk ];
  };
}
