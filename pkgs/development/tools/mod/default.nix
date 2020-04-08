{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mod";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${version}";
    sha256 = "1kcsdi9qls9kgklj96ycyrq5fsz5m2qj3ij63d2rwqjggqk0cab6";
  };

  modSha256 = "0famjypv5qg9lgzw4pz2kz70l50cn6n6nbjyk7jrzmd6bjzd0ypl";

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
