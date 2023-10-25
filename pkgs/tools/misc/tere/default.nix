{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
    sha256 = "sha256-xqbFBRzBfTwSdkC8e85yANdVA45G6E1FYlTXP8QfVIk=";
  };

  cargoHash = "sha256-Y2Zgo/VAJxzQd2cXxyiJS5AqcVRClAuUsEogivK3EJw=";

  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
