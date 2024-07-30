{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jaq";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    rev = "v${version}";
    hash = "sha256-i/VCr12ThKkT8L2lvzWiPD2Ir1WLcbgGYVsUDRgzGLs=";
  };

  cargoHash = "sha256-3F95yv4D2FLuT7+e0LJ0NQ8bjsirCF/qsO0V7WdJS5M=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda siraben ];
    mainProgram = "jaq";
  };
}
