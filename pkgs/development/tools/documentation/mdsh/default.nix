{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "0m3f5mrdmnmkfsy7mc6x3jf4ainmq0z42mv935ikcdbjwwjbd5gq";
  };

  cargoSha256 = "0adc525hbs7j7zasvcdxy7k6pf145hs711hjbzgwf72k514ypyrl";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = https://github.com/zimbatm/mdsh;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
