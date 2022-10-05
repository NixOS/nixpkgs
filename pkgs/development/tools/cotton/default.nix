{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cotton";
  version = "unstable-2022-10-04";

  src = fetchFromGitHub {
    owner = "danielhuang";
    repo = pname;
    rev = "30f3aa7ec6792f3e2dbafc9f4b009b1a6eadc755";
    sha256 = "sha256-jq5aW6dViHTxh2btP5smtcyUSZ1EoMrQVN7K8zs1jJM=";
  };

  cargoSha256 = "sha256-qpV3UriOidIk/0di9d8RjXvjcjgD6dXqg7wLAywI66o=";

  meta = with lib; {
    description = "A package manager for JavaScript projects";
    homepage = "https://github.com/danielhuang/cotton";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
