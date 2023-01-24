{ lib
, rustPlatform
, fetchFromGitHub
, strace
}:

rustPlatform.buildRustPackage rec {
  pname = "strace-analyzer";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "wookietreiber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ICUXedWg7ZT2Uzk7ZLpFqoEXiG4AzvkwCndR2aHKjVI=";
  };

  cargoSha256 = "sha256-p/HYG/KaHtvgvAd+eg1fKmDnLoWCL+XiT66jRBU2xRE=";

  nativeCheckInputs = [ strace ];

  meta = with lib; {
    description = "Analyzes strace output";
    homepage = "https://github.com/wookietreiber/strace-analyzer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
