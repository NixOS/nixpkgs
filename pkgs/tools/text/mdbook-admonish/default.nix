{ lib, stdenv, fetchCrate, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-QvFHpAsQ+S7q/Ye0YEf0phZcVvAs1a80Hd3eIGZBsrI=";
  };

  cargoSha256 = "sha256-v7MGJlDm5nvydjFAZZS94afZY2OVUjJQ9eXYaY9JxBs=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
