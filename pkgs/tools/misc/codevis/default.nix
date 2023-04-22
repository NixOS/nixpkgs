{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "codevis";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${version}";
    hash = "sha256-37It/9e/H/ZxDIAeKIcFNrbMs7GJdo1kDx7gPt+pup4=";
  };

  cargoHash = "sha256-pWf9qIEzuddcwMLtXzzlU+nL8iD0Ey5yj3e7GUzVzSw=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  meta = with lib; {
    description = "A tool to take all source code in a folder and render them to one image";
    homepage = "https://github.com/sloganking/codevis";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
