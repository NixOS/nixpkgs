{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    sha256 = "sha256-KmGAp0EPnnM+hPRpUGsbt+NU2v5mcPaRUqo0pqUr1L8=";
  };

  cargoHash = "sha256-9sOR99CaTyMQoGMKP2Cag6YNxmgEqNPE/kiJPziqB9U=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
    platforms = platforms.linux;
  };
}
