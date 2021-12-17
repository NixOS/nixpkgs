{ stdenv, lib, rustPlatform, fetchFromGitHub, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "15q88ix5800wmqq6nbmnw0gxk0sx1k9iqv1fvy5kcbgcj65acvwx";
  };

  cargoSha256 = "0dlap5db8wvghaqzqbm7q3k38xvncdikq0y9gc55w5hzic63khbx";

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
