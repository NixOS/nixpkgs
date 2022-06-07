{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "1.1.5";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    sha256 = "sha256-E2Oy8ubH4VIpuH4idYNiZJISuYYe+stcUY/atN2JcVw=";
  };

  cargoSha256 = "sha256-S+GcyEYQ4nnVoPMuglTmFdP5j015UyCXMyyhPHa5m8k=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
  };
}
