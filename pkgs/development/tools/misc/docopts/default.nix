{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "docopts";
  version = "0.6.3-rc2";

  src = fetchFromGitHub {
    owner = "docopt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PmsTkPT/sf70MKYLhHvjCDb2o3VQ1k7d++RUW7rcoAg=";
  };

  goPackagePath = "github.com/docopt/${pname}";

  goDeps = ./deps.nix;

  subPackages = [ "./" ];

  postInstall = ''
    install -D -m 755 ./go/src/$goPackagePath/docopts.sh $out/bin/docopts.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/docopt/${pname}";
    description = "docopt CLI tool for shell scripting";
    license = licenses.mit;
    maintainers = [ maintainers.confus ];
    platforms = platforms.linux;
  };
}
