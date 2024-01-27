{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gemget";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "makeworld-the-better-one";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P5+yRaf2HioKOclJMMm8bJ8/BtBbNEeYU57TceZVqQ8=";
  };

  vendorHash = "sha256-l8UwkFCCNUB5zyhlyu8YC++MhmcR6midnElCgdj50OU=";

  meta = with lib; {
    description = "Command line downloader for the Gemini protocol";
    homepage = "https://github.com/makeworld-the-better-one/gemget";
    license = licenses.mit;
    maintainers = with maintainers; [ amfl ];
  };
}
