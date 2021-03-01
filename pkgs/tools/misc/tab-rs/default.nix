{ lib, stdenv, fetchFromGitHub, rustPlatform, IOKit }:

rustPlatform.buildRustPackage rec {
  pname = "tab-rs";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "austinjones";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gyl2dxyhh4d2lpxg9s5cx734sfs1kys5z5hjqfgbiny28hp9sw6";
  };

  cargoSha256 = "1apjzn164kakb2snrq1wfl7grm72hkddi3am6d01h5kkngkp68qm";

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  # many tests are failing
  doCheck = false;

  meta = with lib; {
    description = "Intuitive, config-driven terminal multiplexer designed for software & systems engineers";
    homepage = "https://github.com/austinjones/tab-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
