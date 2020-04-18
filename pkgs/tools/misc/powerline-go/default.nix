{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "06i07m68l24v29j01qp2y91rwsfqh4x1nc8sxkjzrc7q1c7fsc1r";
  };

  modSha256 = "0mz1qrwar9cgrhrgw4z3gwhjj62bnfnn59ji31zkyvwlc1mqh9an";

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
