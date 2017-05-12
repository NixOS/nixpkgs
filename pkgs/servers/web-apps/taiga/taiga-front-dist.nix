{ stdenv, fetchFromGitHub, pkgconfig }:

stdenv.mkDerivation rec {
  name = "taiga-front-dist-${version}";
  version = "3.1.0-stable";

  src = fetchFromGitHub {
    owner = "taigaio";
    repo = "taiga-front-dist";
    rev = "${version}";
    sha256 = "0p9ls2jnqkfb7n345x8yv03ayxa3l9kwgq5mdqaq829gkbkg10ll";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = {
    description = "Project management web application with scrum in mind! Built on top of Django and AngularJS (Front)";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.agpl3;
    maintainers = [];
  };
}
