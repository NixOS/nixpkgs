{ lib, buildGoModule, fetchFromGitHub, go-md2man, installShellFiles }:

buildGoModule rec {
  pname = "vgrep";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "vrothberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8xLyk1iid3xDCAuZwz1oXsEyboLaxvzm1BEyA2snQt4=";
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
