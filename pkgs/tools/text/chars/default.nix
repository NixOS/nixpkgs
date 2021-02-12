{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "chars";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "antifuchs";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pyda3b6svxzc98d7ggl7v9xd0xhilmpjrnajzh77zcwzq42s17l";
  };

  cargoSha256 = "0pqx527cfbza3nb9i3h2945d6nxqssvfivk59hv1rck57nhx63fn";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Commandline tool to display information about unicode characters";
    homepage = "https://github.com/antifuchs/chars";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
