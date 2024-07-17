{ fetchFromGitHub, lib }:

fetchFromGitHub rec {
  pname = "5etools";
  version = "1.175.2";

  owner = "5etools-mirror-1";
  repo = "5etools-mirror-1.github.io";
  rev = "v${version}";
  hash = "sha256-0+QjtcmKsfcSehvn4DChBhSVooy9wlqaSCgeAFgeL+w=";

  meta = with lib; {
    description = "A suite of browser-based tools for players and DMs of D&D 5e";
    homepage = "https://5e.tools";
    changelog = "https://github.com/5etools-mirror-1/5etools-mirror-1.github.io/releases/tag/v${version}";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ urandom ];
    hydraPlatforms = [ ]; # src tarball is 4.7G, unpackeed 4.8G, exceeds hydras output limit
  };
}
