{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cshatag";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jSRMNLS+JnA3coZf9zkOL/buxZubhbftXnxDJx0nwuU=";
  };

  vendorSha256 = "sha256-BX7jbYhs3+yeOUvPvz08aV2p14bXNGTag4QYkCHr5DQ=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    # Install man page
    install -D -m755 -t $out/share/man/man1/ cshatag.1
  '';

  meta = with lib; {
    description = "A tool to detect silent data corruption";
    homepage = "https://github.com/rfjakob/cshatag";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
