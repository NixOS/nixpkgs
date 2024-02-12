{ lib, buildGoModule, fetchFromGitHub, go-md2man, installShellFiles }:

buildGoModule rec {
  pname = "vgrep";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "vrothberg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+KZNNkTuZyF02YDZX3u1KdhOcZ3+Ud6aDGL/sGUN1hI=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
