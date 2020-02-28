{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "shell-hist";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jamesmunns";
    repo = "shell-hist";
    rev = "158de8c3908b49530ecd76bf6e65c210f351ef82";
    sha256 = "0kc128xnnp1d56if70vfv0w3qnwhljhbnvzwwb7hfm3x2m0vqrqf";
  };

  cargoSha256 = "0mfgax937na351qvi5n6s1ql9136djqiydzyfyax4684sp3kp613";

  meta = with lib; {
    description = "Inspect your shell history";
    homepage = "https://github.com/jamesmunns/shell-hist";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.all;
  };
}
