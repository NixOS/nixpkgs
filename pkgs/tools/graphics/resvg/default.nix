{ stdenv, lib, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3WFzLyg6335twcAMIjzza9r45ljcFlAzvTqyqXOfs1A=";
  };

  cargoSha256 = "sha256-twKiuxRpsiJu+hHrg6kUclX9+BWPUop492C+CkwQF2k=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    changelog = "https://github.com/RazrFalcon/resvg/raw/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
