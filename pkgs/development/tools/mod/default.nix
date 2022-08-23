{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mod";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${version}";
    sha256 = "sha256-ZmBh59za1OaFObmNzLtuLKkbR0mBeh6OeD+EHton0nE=";
  };

  vendorSha256 = "sha256-+87QR3l9XBJVsx4+8ixaidTHaKyLAxMA9CguOlTVoHM=";

  doCheck = false;

  subPackages = [ "cmd/mod" ];

  meta = with lib; {
    description = "Automated Semantic Import Versioning Upgrades for Go";
    longDescription = ''
      Command line tool to upgrade/downgrade Semantic Import Versioning in Go
      Modules.
      '';
    homepage = "https://github.com/marwan-at-work/mod";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
