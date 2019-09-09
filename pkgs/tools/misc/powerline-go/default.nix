{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "powerline-go";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "justjanne";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hgc0ji9jcsq5qnvx54dvpq8qx80mgdbvkllzavnvqr7md638zk9";
  };

  modSha256 = "0800r08rawv4fz08d332z0fy6pd16l1dyflz3h91ba00g59wc2ah";

  meta = with stdenv.lib; {
    description = "A Powerline like prompt for Bash, ZSH and Fish";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sifmelcara ];
  };
}
