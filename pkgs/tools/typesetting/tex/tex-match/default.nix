{
  rustPlatform,
  fetchFromGitHub,
  gtk3,
  pkg-config,
  glib,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-match";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "zoeyfyi";
    repo = "TeX-Match";
    rev = "v${version}";
    sha256 = "1yb81j7mbqqb8jcn78dx4ydp7ncbzvaczkli6cqay5jf5j6dbk1z";
  };

  nativeBuildInputs = [
    pkg-config
    glib
  ];

  buildInputs = [ gtk3 ];

  cargoSha256 = "13ihwrckpsb4j1ai923vh151frw0yriwg9yylj9lk0ycps51y1sn";

  meta = with lib; {
    description = "Search through over 1000 different LaTeX symbols by sketching. A desktop version of detexify";
    mainProgram = "tex-match";
    homepage = "https://tex-match.zoey.fyi/";
    license = licenses.mit;
    maintainers = [ maintainers.bootstrap-prime ];
    platforms = platforms.linux;
  };
}
