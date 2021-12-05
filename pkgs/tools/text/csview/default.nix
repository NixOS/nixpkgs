{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FrdW3f/ydjClgySEa2AIlAC9NOAr9cE4W67zXmlrUrQ=";
  };

  cargoSha256 = "sha256-cew6czpBGNF3kulgdmfoWl/4f1AyKvHTIk/3eGEwkhE=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
