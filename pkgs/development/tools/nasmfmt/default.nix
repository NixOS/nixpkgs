{ lib, buildGoPackage, fetchFromGitHub, go }:

buildGoPackage rec {
  pname = "nasmfmt";
  version = "unstable-2021-04-24";

  src = fetchFromGitHub {
    owner = "yamnikov-oleg";
    repo = "nasmfmt";
    rev = "efba220c5252eb717f080d266dcc8304efdeab40";
    sha256 = "sha256-snhXF+IP0qzl43rKQ0Ugfo1zv3RyNfjxnMpjZEBgPQg=";
  };

  goPackagePath = "github.com/yamnikov-oleg/nasmfmt";

  meta = with lib; {
    description = "Formatter for NASM source files";
    homepage = "https://github.com/yamnikov-oleg/nasmfmt";
    platforms = go.meta.platforms;
    license = licenses.mit;
    maintainers = with maintainers; [ ckie ];
  };
}
