{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pv0zCtVHTjzkXK5EZhu6jviMJF0p9dvAuYcA6khiIos=";
  };

  cargoSha256 = "sha256-uMBwEbxI8hjoFMlH+oquHvKdyLUC9bnO5uMFHkyZjgY=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
