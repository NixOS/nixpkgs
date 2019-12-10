{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "reviewdog";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1npawdvryrxrdfkv4j1jk63l3mwsdgsj85k9yqyhrrphk2w4s1cr";
  };

  modSha256 = "0a6bmwysgvwpddh2mp228s2brb0kqfcxqjffs2pabf7ym5flmz0g";

  subPackages = [ "cmd/reviewdog" ];

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/reviewdog/reviewdog/commands.Version=${version}" ];

  meta = with lib; {
    description = "Automated code review tool integrated with any code analysis tools regardless of programming language";
    homepage = "https://github.com/reviewdog/reviewdog";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
