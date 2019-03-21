{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  name = "mod-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "marwan-at-work";
    repo = "mod";
    rev = "v${version}";
    sha256 = "1v7qy0q6fb9amcggwzdygl290zhr3w3zgmig2rm5zx91kw973sqc";
  };

  modSha256 = "0j0c5idgwclszsmay7av9y3lcwfk72ml06nwll3fz404hx8vla6y";

  subPackages = [ "cmd/mod" ];

  meta = with lib; {
    description = "Automated Semantic Import Versioning Upgrades for Go";
    longDescription = ''
      Command line tool to upgrade/downgrade Semantic Import Versioning in Go
      Modules.
      '';
    homepage = https://github.com/marwan-at-work/mod;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
