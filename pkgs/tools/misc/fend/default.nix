{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zKjYUkkm15YRF0YFJKi2A6twvmHuEyxdWcNs37r2dJg=";
  };

  cargoSha256 = "sha256-rCJn1dDSwKMmwF7m7n+Lf/7+sLd964r8EU7/VdeD9rI=";

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
