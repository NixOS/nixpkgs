{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.17";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    rev = version;
    hash = "sha256-LZOB0HF6Chs1BxRPqQnMQrjk2CbFR2UoVQl+W32R9yI=";
  };

  cargoHash = "sha256-9io8cSKwBONw8epPw5foa+/ur4VvvjQrOcj5Hse3oJ4=";

  meta = with lib; {
    description = "A formatter for the leptos view! macro";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
