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

  cargoSha256 = "11kzl0ns84xhdacn0k7nilgzgpwazmaaqdjf2kcarxf2h01b0rjv";

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = https://github.com/zimbatm/mdsh;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
