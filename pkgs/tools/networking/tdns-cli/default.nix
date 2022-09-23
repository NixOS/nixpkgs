{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tdns-cli";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "rotty";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nn036in5j1h0vxkwif0lf7fn900zy4f4kxlzy6qdx3jakgmxvwh";
  };

  cargoSha256 = "sha256-O4n38dla2WgZ4949Ata6AYbZF9LMnXDyuFNoXRrTN7I=";

  meta = with lib; {
    description = "DNS tool that aims to replace dig and nsupdate";
    homepage = "https://github.com/rotty/tdns-cli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ astro ];
    mainProgram = "tdns";
  };
}
