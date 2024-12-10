{
  lib,
  buildGoPackage,
  fetchFromGitHub,
}:

buildGoPackage rec {
  pname = "docopts";
  version = "0.6.4-with-no-mangle-double-dash";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zxax0kl8wqpkzmw9ij4qgfhjbk4r7996pjyp9xf5icyk8knp00q";
  };

  goPackagePath = "github.com/docopt/${pname}";

  goDeps = ./deps.nix;

  subPackages = [ "./" ];

  postInstall = ''
    install -D -m 755 ./go/src/$goPackagePath/docopts.sh $out/bin/docopts.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/docopt/${pname}";
    description = "docopt CLI tool for shell scripting";
    license = licenses.mit;
    maintainers = [ maintainers.confus ];
    platforms = platforms.unix;
  };
}
