{ lib, buildGoModule, fetchFromGitHub, go-md2man, installShellFiles }:

buildGoModule rec {
  pname = "vgrep";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "vrothberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1waxp66286q325avvsq58s8qkfjqa39s5p8c3z59scpm0244nr80";
  };

  vendorSha256 = null;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  nativeBuildInputs = [ go-md2man installShellFiles ];

  postBuild = ''
    sed -i '/SHELL= /d' Makefile
    make docs
    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "User-friendly pager for grep/git-grep/ripgrep";
    homepage = "https://github.com/vrothberg/vgrep";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zowoq ];
  };
}
