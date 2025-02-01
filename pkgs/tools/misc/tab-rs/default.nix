{ lib, stdenv, fetchFromGitHub, rustPlatform, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "tab-rs";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "austinjones";
    repo = pname;
    rev = "v${version}";
    sha256 = "1crj0caimin667f9kz34c0sm77892dmqaf1kxryqakqm75az5wfr";
  };

  cargoSha256 = "0v5vkxr2sncw4r4pwvk0jbk4as7zwwfvjk2cpj9872zp07s35a77";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  # many tests are failing
  doCheck = false;

  meta = with lib; {
    description = "Intuitive, config-driven terminal multiplexer designed for software & systems engineers";
    homepage = "https://github.com/austinjones/tab-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "tab";
    broken = (stdenv.isDarwin && stdenv.isAarch64); # Added 2023-11-13
  };
}
