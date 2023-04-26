{ lib, stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "termbook";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bo3DI0cMXIfP7ZVr8MAW/Tmv+4mEJBIQyLvRfVBDG8c=";
  };

  cargoSha256 = "sha256-+LQriLzLYt+mG2qoQeD9/Ay51TKMZpklLH72qrcSV0U=";

  meta = with lib; {
    description = "A runner for `mdbooks` to keep your documentation tested.";
    license = licenses.asl20;
    maintainers = with maintainers; [ phaer ];
    homepage = "https://github.com/Byron/termbook/";
  };
}
