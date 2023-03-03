{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, perl
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "findomain";
  version = "8.2.2";

  src = fetchFromGitHub {
    owner = "Edu4rdSHL";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9mtXtBq08lL6qQg1Pq1WNwbkG0yi99mCpxNuBvr14ms=";
  };

  cargoHash = "sha256-pKNqO43aFXZ/cbjNWt3tmBBbSTSKqVF7biNCPI1flvI=";

  nativeBuildInputs = [
    installShellFiles
    perl
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  postInstall = ''
    installManPage ${pname}.1
  '';

  meta = with lib; {
    description = "The fastest and cross-platform subdomain enumerator";
    homepage = "https://github.com/Edu4rdSHL/findomain";
    changelog = "https://github.com/Findomain/Findomain/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
