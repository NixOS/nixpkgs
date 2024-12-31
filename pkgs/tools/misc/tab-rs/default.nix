{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  IOKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "tab-rs";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "austinjones";
    repo = pname;
    rev = "v${version}";
    sha256 = "1crj0caimin667f9kz34c0sm77892dmqaf1kxryqakqm75az5wfr";
  };

  cargoHash = "sha256-56gy9AH3i4OSvExMuR3n/2hF5pJgbn5JJpxZLXKfu2w=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ IOKit ];

  # many tests are failing
  doCheck = false;

  meta = with lib; {
    description = "Intuitive, config-driven terminal multiplexer designed for software & systems engineers";
    homepage = "https://github.com/austinjones/tab-rs";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "tab";
    broken = (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64); # Added 2023-11-13
  };
}
