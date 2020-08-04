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

  vendorSha256 = "0dkgp9vlb76la0j439w0rb548qg5v8648zryk3rqgfhd4qywlk11";

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
