{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G/7Ezyfp9vkG1QHTG9Xg6mZ3qhQpx952i7rsSr3fFwY=";
  };

  vendorSha256 = "0kk8ci7vprqw4v7cigspshfd13k2wyy4pdkxf11pqc2fz8j07kh9";

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
