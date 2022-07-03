{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ikill";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "pjmp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sxFuDHlrEO2/gA9I++yNAISvsF7wFjSMUI+diVM/+EI=";
  };

  cargoSha256 = "sha256-dJa+bXJTA2Jju1p29Fyj87N0Pr/l6XRr3QqemhD2BAA=";

  meta = with lib; {
    description = "Interactively kill running processes";
    homepage = "https://github.com/pjmp/ikill";
    maintainers = with maintainers; [ zendo ];
    license = [ licenses.mit ];
    platforms = platforms.linux;
  };
}
