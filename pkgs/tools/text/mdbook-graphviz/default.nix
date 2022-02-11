{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yY8ZdRNP0G9dwrwUtNZIaodIlEK4GRgZQ5D1GpLhDGg=";
  };

  cargoSha256 = "sha256-d8/xa2Aq6g0Kvqq11kzVTp1oooN6dPowpKW0uenBevw=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  checkInputs = [ graphviz ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering Graphviz graphs to HTML at build time.";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
