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

  cargoSha256 = "1sm2fd3dhs59rvmfjzrfz0qwqzyc9dllb8ph0wc2x0r3px16c71x";

  meta = with lib; {
    description = "Search through over 1000 different LaTeX symbols by sketching. A desktop version of detexify";
    homepage = "https://tex-match.zoey.fyi/";
    license = licenses.mit;
    maintainers = [ maintainers.bootstrap-prime ];
    platforms = platforms.linux;
  };
}
