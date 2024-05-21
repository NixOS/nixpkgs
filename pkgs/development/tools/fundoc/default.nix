{ lib, rustPlatform, fetchFromGitHub, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "fundoc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "daynin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8WWaYgfqGWrTV2EEeSPz1BN2ur7gsxFiHeDNMJdVDcw=";
  };

  cargoPatches = [
    # updates outdated lock file and fixes a test
    (fetchpatch {
      name = "fix-tests.patch";
      url = "https://github.com/daynin/fundoc/commit/7dd3cf53a1d1ed72b00bf38ea3a45ba4590da7ef.patch";
      hash = "sha256-9Xsw2P4t9gzwc/qDU6U5+HZevPiQOOQo88gybC8QpyM=";
    })
  ];

  cargoHash = "sha256-yapFUkG2JfGb3N3iVEDpQunOyRnbNTs+q3zQ23B23/s=";

  meta = with lib; {
    description = "Language agnostic documentation generator";
    mainProgram = "fundoc";
    homepage = "https://github.com/daynin/fundoc";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
