{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "sshs";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "quantumsheep";
    repo = pname;
    rev = version;
    sha256 = "KD971dGm1oQt9GbiUGZm2k4SJrBAA9rnHj7Gu0t3SJw=";
  };

  vendorSha256 = "OCh37wjSs40Q0VQmoc1nXQ4nWddnoUCrI5xgxpxR/Ec=";

  ldflags = [ "-s" "-w" "-X github.com/quantumsheep/sshs/cmd.Version=${version}" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Terminal user interface for SSH";
    homepage = "https://github.com/quantumsheep/sshs";
    license = licenses.mit;
    maintainers = with maintainers; [ not-my-segfault ];
  };
}
