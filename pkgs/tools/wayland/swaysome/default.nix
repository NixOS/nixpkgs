{ lib
, rustPlatform
, fetchFromGitLab
}:

rustPlatform.buildRustPackage rec {
  pname = "swaysome";
  version = "2.1.0";

  src = fetchFromGitLab {
    owner = "hyask";
    repo = pname;
    rev = version;
    sha256 = "sha256-U5W/9VL1t1/R4ADPxseBV6CMKx04I4vbp7sFmSqRZXk=";
  };

  cargoHash = "sha256-QA3EQsYgjwx8QX50yaxiJyAPDlpYYqiqLiXco1kJmw0=";

  meta = with lib; {
    description = "Helper to make sway behave more like awesomewm";
    homepage = "https://gitlab.com/hyask/swaysome";
    license = licenses.mit;
    maintainers = with maintainers; [ esclear ];
    platforms = platforms.linux;
    mainProgram = "swaysome";
  };
}
