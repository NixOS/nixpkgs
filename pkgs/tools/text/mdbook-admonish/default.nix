{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform, CoreServices }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AGOq05NevkRU8qHsJIWd2WfZ4i7w/wexf6c0fUAaoLg=";
  };

  cargoPatches = [
    # https://github.com/tommilligan/mdbook-admonish/pull/33
    (fetchpatch {
      name = "update-mdbook-for-rust-1.64.patch";
      url = "https://github.com/tommilligan/mdbook-admonish/commit/650123645b18a3f8ed170738c7c1813315095ed9.patch";
      hash = "sha256-8LMk+Dgz9k0g9fbGGC0X2byyJtfDDgvdGxO06mD6GDI=";
    })
  ];

  cargoHash = "sha256-5PWfze00/mWmzYqP5M1pAPt+SuknpU9dc0B7RSikuTE=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
    license = licenses.mit;
    maintainers = with maintainers; [ jmgilman ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
