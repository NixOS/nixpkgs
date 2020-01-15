{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
  version = "unstable-2018-10-05";

  src = fetchFromGitHub {
    owner = "ivanceras";
    repo = pname;
    rev = "43fb0364e989d0e9a7656b148c947d47cc769622";
    sha256 = "1imjj57dx1af3wrs214yzaa2qfk8ld00nj3nx4z450gw2xjjj1gw";
  };

  sourceRoot = "source/svgbob_cli";

  cargoSha256 = "0mnq1s809f394x83gjv9zljr07c94k48zkrwxs6ibi19shgmrnnd";

  # Test tries to build outdated examples
  doCheck = false;

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
