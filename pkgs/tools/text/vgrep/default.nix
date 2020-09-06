{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "vgrep";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "vrothberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "109j04my2xib8m52a0337996a27nvfgzackpg20zs3nzn66dmvb7";
  };

  vendorSha256 = null;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "User-friendly pager for grep/git-grep/ripgrep";
    homepage = "https://github.com/vrothberg/vgrep";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zowoq ];
  };
}
