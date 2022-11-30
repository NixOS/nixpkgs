{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "threatest";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9/TIiBp3w7NaECX929Tai5nqHKxb7YxYEr2hAl2ttsM=";
  };

  vendorHash = "sha256-vTzgxByZ2BC7nuq/+LJV7LR0KsUxh1EbHFe81PwqCJc=";

  meta = with lib; {
    description = "Framework for end-to-end testing threat detection rules";
    homepage = "https://github.com/DataDog/threatest";
    changelog = "https://github.com/DataDog/threatest/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
