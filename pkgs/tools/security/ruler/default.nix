{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "ruler";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = pname;
    rev = version;
    hash = "sha256-m41U24OoUV1ubxvZBfaANGs58o+4q7XveR+Jq38/swQ=";
  };

  vendorHash = "sha256-z9SKDpkDFsDVMvyaTAtB8tTcXsgVYU+Ql4QlyfeRhZM=";

  meta = with lib; {
    description = "Tool to abuse Exchange services";
    homepage = "https://github.com/sensepost/ruler";
    license = with licenses; [ cc-by-nc-40 ];
    maintainers = with maintainers; [ fab ];
  };
}
