{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.12";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-1q1TOwKC2Tse/Ct/6Nw7YiOviJyBZAsOBEp3sT4N0ss=";
  };

  cargoSha256 = "sha256-x8+7sZJnA+kEwKAu8DBF8z7JhWjJ6ZFiLaQP8kFOt08=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
