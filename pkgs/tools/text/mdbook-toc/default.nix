{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-toc";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = pname;
    rev = version;
    sha256 = "sha256-OFNp+kFDafYbzqb7xfPTO885cAjgWfNeDvUPDKq5GJU=";
  };

  cargoHash = "sha256-95W0gERjwL9r0+DOgxQu+sjSFSThWeShLAqlDQiGxFw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Preprocessor for mdbook to add inline Table of Contents support";
    mainProgram = "mdbook-toc";
    homepage = "https://github.com/badboy/mdbook-toc";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
