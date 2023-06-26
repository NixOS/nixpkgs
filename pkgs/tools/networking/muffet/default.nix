{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "muffet";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "raviqqe";
    repo = "muffet";
    rev = "v${version}";
    hash = "sha256-SQtAT4vK1jLwwMha/HuJjh3BtDTdxV7BDgmwxlK+lqc=";
  };

  vendorHash = "sha256-/qK4x44J2fDSXxGK3kczWY4NZVPPhRo4NMnyxV6W6CY=";

  meta = with lib; {
    description = "A website link checker which scrapes and inspects all pages in a website recursively";
    homepage = "https://github.com/raviqqe/muffet";
    changelog = "https://github.com/raviqqe/muffet/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
