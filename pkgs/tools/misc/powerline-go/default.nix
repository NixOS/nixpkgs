{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "135j18d53nhg6adjd2hax067c5f1py9fyprzfcr3plsxnaki2hrx";
  };

  modSha256 = "0mz1qrwar9cgrhrgw4z3gwhjj62bnfnn59ji31zkyvwlc1mqh9an";

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
