{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "chars";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "antifuchs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aswosSXAh0wkO4N/y/H54dufMDrloWjpjrSWHvHR1rc=";
  };

  cargoSha256 = "sha256-CqPmasdpXWjCn65G2Ua0h3v+TVP0QPFAdtKOFyoYW/0=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Commandline tool to display information about unicode characters";
    homepage = "https://github.com/antifuchs/chars";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
