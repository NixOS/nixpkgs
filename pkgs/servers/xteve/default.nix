{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xteve";
  version = "2.2.0.200";

  src = fetchFromGitHub {
    owner = "xteve-project";
    repo = "xTeVe";
    rev = version;
    hash = "sha256-hD4GudSkGZO41nR/CgcMg/SqKjpAO1yJDkfwa8AUges=";
  };

  vendorHash = "sha256-oPkSWpqNozfSFLIFsJ+e2pOL6CcR91YHbqibEVF2aSk=";

  meta = with lib; {
    description = "M3U Proxy for Plex DVR and Emby Live TV";
    homepage = "https://github.com/xteve-project/xTeVe";
    license = licenses.mit;
    maintainers = with maintainers; [ nrhelmi ];
  };
}
