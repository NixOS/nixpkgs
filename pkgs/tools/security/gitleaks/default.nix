{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pdbkjx8h6ijypsxyv34lykymaqf8wnfyjk3ldp49apbx01bl34y";
  };

  vendorSha256 = "0kk8ci7vprqw4v7cigspshfd13k2wyy4pdkxf11pqc2fz8j07kh9";

  meta = with lib; {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys, and tokens in git repos.
    '';
    homepage = "https://github.com/zricethezav/gitleaks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
