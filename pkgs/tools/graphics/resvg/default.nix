{ stdenv, lib, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/r1rTU+te8pKKiPGCHJTTBkg9RZ/N1yFTlaDAhWWxjs=";
  };

  cargoSha256 = "sha256-pHZRKXZo5fyyXjgNTDBZjRiMDOaoCfFUSl53yE2t210=";

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
