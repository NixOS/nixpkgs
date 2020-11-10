{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "resvg";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qaca8wqwi2wqqx1yladjb4clgqdzsm8b7qsiaw0qascddjw1mcc";
  };

  cargoSha256 = "1y10xzdf5kxbi9930qfsmryrbrkx1wmc5b216l9wcxq6cd77hxy2";

  doCheck = false;

  meta = with lib; {
    description = "An SVG rendering library";
    homepage = "https://github.com/RazrFalcon/resvg";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
  };
}
