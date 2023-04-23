{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, CoreServices
}:

let
  pname = "mdbook-epub";
  version = "unstable-2022-12-25";
in rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "michael-f-bryan";
    repo = pname;
    rev = "2e1e48d0d1a1b4c1b0f866267e6666b41c598225";
    hash = "sha256-wjn/7dv/Z2OmwvH/XaEeCz/JOvJWlMJ60q5qozzOEWY=";
  };

  cargoHash = "sha256-4oSpQUYJDK0srABZMwJ8x8jv6DOnLShXSnjLjf8c9Ac=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    bzip2
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  meta = with lib; {
    description = "mdbook backend for generating an e-book in the EPUB format";
    homepage = "https://michael-f-bryan.github.io/mdbook-epub";
    license = licenses.mpl20;
    maintainers = with maintainers; [ yuu ];
  };
}
