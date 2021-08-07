{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "7.5.0";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s7EOCoGciGT5+Fose9BffsHHE/SsSMmNoWGmeAv6Agk=";
  };

  vendorSha256 = "sha256-Cc4DJPpOMHxDcH22S7znYo7QHNRXv8jOJhznu09kaE4=";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-s -w -X github.com/zricethezav/gitleaks/v${lib.versions.major version}/version.Version=${version}")
  '';

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
