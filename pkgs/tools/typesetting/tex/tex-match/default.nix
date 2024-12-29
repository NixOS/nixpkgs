{ rustPlatform, fetchFromGitHub, gtk3, pkg-config, glib, lib }:

rustPlatform.buildRustPackage rec {
  pname = "tex-match";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "zoeyfyi";
    repo = "TeX-Match";
    rev = "v${version}";
    sha256 = "1yb81j7mbqqb8jcn78dx4ydp7ncbzvaczkli6cqay5jf5j6dbk1z";
  };

  nativeBuildInputs = [ pkg-config glib ];

  buildInputs = [ gtk3 ];

  cargoHash = "sha256-Vgcfir7Mg0mTpN6nx2P2gGcXSoB7iBRVkGTpO1nmMI4=";

  meta = with lib; {
    description = "Search through over 1000 different LaTeX symbols by sketching. A desktop version of detexify";
    mainProgram = "tex-match";
    homepage = "https://tex-match.zoey.fyi/";
    license = licenses.mit;
    maintainers = [ maintainers.bootstrap-prime ];
    platforms = platforms.linux;
  };
}
