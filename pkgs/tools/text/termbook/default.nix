{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "termbook-cli";
  version = "1.4.6";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "termbook";
    rev = "v${version}";
    sha256 = "Bo3DI0cMXIfP7ZVr8MAW/Tmv+4mEJBIQyLvRfVBDG8c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  # update dependencies to fix build failure caused by unaligned packed structs
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A runner for `mdbooks` to keep your documentation tested";
    homepage = "https://github.com/Byron/termbook/";
    changelog = "https://github.com/Byron/termbook/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ phaer ];
  };
}
