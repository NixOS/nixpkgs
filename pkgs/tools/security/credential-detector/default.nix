{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "credential-detector";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ynori7";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zUQRzlp/7gZhCm5JYu9kYxcoFjDldCYKarRorOHa3E0=";
  };

  vendorSha256 = "sha256-VWmfATUbfnI3eJbFTUp6MR1wGESuI15PHZWuon5M5rg=";

  meta = with lib; {
    description = "Tool to detect potentially hard-coded credentials";
    homepage = "https://github.com/ynori7/credential-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
