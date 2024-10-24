{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cshatag";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RqQPbqfliKg7XPA/C9D7Aq1SsN+tAW44tAFHt9p8Py0=";
  };

  vendorHash = "sha256-OYMnZub4Yi11uMHzL1O5l6/J1md6ORS5cWm9K4yP92Q=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    # Install man page
    install -D -m755 -t $out/share/man/man1/ cshatag.1
  '';

  meta = with lib; {
    description = "Tool to detect silent data corruption";
    mainProgram = "cshatag";
    homepage = "https://github.com/rfjakob/cshatag";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
