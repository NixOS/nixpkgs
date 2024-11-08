{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "angle-grinder";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "rcoh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1SZho04qJcNi84ZkDmxoVkLx9VJX04QINZQ6ZEoCq+c=";
  };

  cargoHash = "sha256-+l0+zaZSPOk4gJLHZ9LFFbYlZ5vkS68Jg2dWPHSkzKw=";

  meta = with lib; {
    description = "Slice and dice logs on the command line";
    homepage = "https://github.com/rcoh/angle-grinder";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
    mainProgram = "agrind";
  };
}
