{ buildGoModule, fetchFromGitHub, lib, installShellFiles }:

buildGoModule rec {
  pname = "lf";
  version = "24";

  src = fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "r${version}";
    sha256 = "0nc7vfkaxxl2a201wnbz74an3siz8cjwrfylx17v6al5n93vxip0";
  };

  vendorSha256 = "sha256-ujQh4aE++K/fn3PJqkAbTtwRyJPSI9TJQ1DvwLF9etU=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X main.gVersion=r${version}" ];

  postInstall = ''
    install -D --mode=444 lf.desktop $out/share/applications/lf.desktop
    installManPage lf.1
    installShellCompletion etc/lf.{zsh,fish}
  '';

  meta = with lib; {
    description = "A terminal file manager written in Go and heavily inspired by ranger";
    longDescription = ''
      lf (as in "list files") is a terminal file manager written in Go. It is
      heavily inspired by ranger with some missing and extra features. Some of
      the missing features are deliberately omitted since it is better if they
      are handled by external tools.
    '';
    homepage = "https://godoc.org/github.com/gokcehan/lf";
    changelog = "https://github.com/gokcehan/lf/releases/tag/r${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
  };
}
