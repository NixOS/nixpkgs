{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7AppXnU9VQx1CMyK2evWtRFVb8qvgSzKp+oFKoIGR9w=";
  };

  cargoHash = "sha256-npbvKwxf6OxNw340yZ9vrQkXrZxD4G8yhZZEdDLwLs8=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    mainProgram = "csview";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
