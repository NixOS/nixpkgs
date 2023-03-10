{ lib
, buildGoModule
, fetchFromGitLab
}:

buildGoModule rec {
  pname = "check";
  version = "unstable-2018-12-24";
  rev = "ccaba434e62accd51209476ad093810bd27ec150";

  src = fetchFromGitLab {
    owner = "opennota";
    repo = "check";
    inherit rev;
    sha256 = "sha256-u8U/62LZEn1ffwdGsUCGam4HAk7b2LetomCLZzHuuas=";
  };

  vendorSha256 = "sha256-DyysiVYFpncmyCzlHIOEtWlCMpm90AC3gdItI9WinSo=";

  meta = with lib; {
    description = "A set of utilities for checking Go sources";
    homepage = "https://gitlab.com/opennota/check";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
