{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "golines";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2K9KAg8iSubiTbujyFGN3yggrL+EDyeUCs9OOta/19A=";
  };

  vendorSha256 = "sha256-rxYuzn4ezAxaeDhxd8qdOzt+CKYIh03A9zKNdzILq18=";

  meta = with lib; {
    description = "A golang formatter that fixes long lines";
    homepage = "https://github.com/segmentio/golines";
    license = licenses.mit;
    maintainers = with maintainers; [ meain ];
  };
}
