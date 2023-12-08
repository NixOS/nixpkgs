{ lib, fetchFromGitHub }: rec {
  name = "uptrace";
  version = "1.6.0-rc.3";

  src = (fetchFromGitHub {
    owner = name;
    repo = name;
    rev = "v${version}";
    hash = "sha256-f9Mu/DhcfuZwY4xtdc09zYwHOUoKlPrZckFr7p3b4m8=";
    fetchSubmodules = true;
  }).overrideAttrs (_: {
    GIT_CONFIG_COUNT = 1;
    GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
    GIT_CONFIG_VALUE_0 = "git@github.com:";
  });

  pnpmHash = "sha256-x46wV/hbwC8YRQKJZVJ22Mec/6z7Av93jLMTjzntLZg=";
  vendorHash = "sha256-/3GYxVrJ7F3AN2lGtyh/DZo71R3hd0s3ALm1NTRnStM=";

  meta = with lib; {
    homepage = "https://uptrace.dev/";
    license = licenses.agpl3;
    maintainers = with maintainers; [ fionera ];
  };
}
