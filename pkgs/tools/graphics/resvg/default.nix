{ stdenv, lib, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FjL/7SC1XtQyI+vlkDbQR2848vhV4Lvx3htSN3RSohw=";
  };

  cargoSha256 = "sha256-FfTkturHQqnTAzkEHDn/M/UiLMH1L/+Kv/zov8n8sek=";

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
