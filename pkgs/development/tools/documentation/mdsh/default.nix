{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "1751lll93cimyj7bxxdwdxn5w0zb2mzjpbnk1c93jfsvzlz1wzbl";
  };

  cargoSha256 = "0b8rg4pz4mpm60iwwmfw4l1p1g9sh1fwf693aqxi8g4vrjf0zniv";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = https://github.com/zimbatm/mdsh;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
