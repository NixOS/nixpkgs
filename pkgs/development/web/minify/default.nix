{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "minify";
  version = "2.5.0";

  goPackagePath = "github.com/tdewolff/minify";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ja26fs7klzggmfqvz5nzj9icaa8r8h4a91qg8rj4gx5cnvwx38d";
  };

  modSha256 = "0kff2nj66bifbfi8srcvcsipbddw43mvjdwlq0lz04qak524pbvr";

  meta = with lib; {
    description = "Minifiers for web formats";
    license = licenses.mit;
    homepage = https://go.tacodewolff.nl/minify;
    platforms = platforms.all;
  };
}
