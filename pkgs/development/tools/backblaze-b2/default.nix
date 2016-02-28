{ stdenv, lib, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  name = "backblaze-b2-0.3.10";

  src = fetchFromGitHub {
    owner = "Backblaze";
    repo = "B2_Command_Line_Tool";
    rev = "b097f0f04d3f88d7a372b50ee6db1f89a5249028";
    sha256 = "1rcy8180476cpmrbls4424qbq8nyq7mxkfikd52a8skz7rd5ljc6";
  };
  
  buildInputs = with pkgs; [ python2 ];

  doCheck = true;
  checkPhase = ''
    python test_b2_command_line.py test
  '';

  installPhase = ''
    install -Dm755 b2 "$out/bin/backblaze-b2"
  '';

  meta = with stdenv.lib; {
    description = "Command-line tool for accessing the Backblaze B2 storage service";
    homepage    = https://github.com/Backblaze/B2_Command_Line_Tool;
    license     = licenses.mit;
    maintainers = with maintainers; [ kevincox ];
    platforms   = platforms.unix;
  };
}
