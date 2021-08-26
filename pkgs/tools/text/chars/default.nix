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

  cargoSha256 = "0ywywbcnc9jm0cfd6kbq8vl6r5dl16sxn7pwi2k6l0sj75pm1i6h";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Commandline tool to display information about unicode characters";
    homepage = "https://github.com/antifuchs/chars";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
