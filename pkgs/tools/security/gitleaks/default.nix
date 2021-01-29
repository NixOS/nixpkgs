{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sc8tBgFR5D+zZFg9qT9uE11LHdTPqkWUtiwAmm7cySs=";
  };

  vendorSha256 = "sha256-Cc4DJPpOMHxDcH22S7znYo7QHNRXv8jOJhznu09kaE4=";

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
