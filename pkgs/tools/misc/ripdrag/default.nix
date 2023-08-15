{ lib, rustPlatform, fetchFromGitHub, pkg-config, wrapGAppsHook4, gtk4 }:

rustPlatform.buildRustPackage rec {
  pname = "ripdrag";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "nik012003";
    repo = "ripdrag";
    rev = "v${version}";
    hash = "sha256-Omq5y6ECo+3thhz88IMZJGkRNlAEuMAMbljVKXzxSQc=";
  };

  cargoHash = "sha256-NQHFnA/9K8V8sxX9Lzoh6tuKvMmx7FMd8lTTPiQ+xnU=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];

  buildInputs = [ gtk4 ];

  meta = with lib; {
    description = "An application that lets you drag and drop files from and to the terminal";
    homepage = "https://github.com/nik012003/ripdrag";
    changelog = "https://github.com/nik012003/ripdrag/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
