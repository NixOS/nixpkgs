{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mod";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${version}";
    sha256 = "sha256-QkLARUN/NiN0D6VEhosdFJSce6DP+sWRWFwAEocZaOQ=";
  };

  vendorHash = "sha256-5A4W99wcuXMWH0s+uykBWuKCxo8wr3GbTpUKj+Ql0os=";

  doCheck = false;

  subPackages = [ "cmd/mod" ];

  meta = with lib; {
    description = "Automated Semantic Import Versioning Upgrades for Go";
    mainProgram = "mod";
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
