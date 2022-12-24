{ lib, buildGoModule, fetchFromGitHub }:

let
  owner = "xteve-project";
  repo  = "xTeVe";
  version = "2.2.0.200";

in buildGoModule rec {
  pname = "xteve";
  inherit version;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = version;
    sha256 = "sha256-hD4GudSkGZO41nR/CgcMg/SqKjpAO1yJDkfwa8AUges=";
  };

  vendorSha256 = "sha256-oPkSWpqNozfSFLIFsJ+e2pOL6CcR91YHbqibEVF2aSk=";

  meta = with lib; {
    description = ''
      M3U Proxy for Plex DVR and Emby Live TV.
    '';
    homepage = "https://github.com/xteve-project/xTeVe";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
