{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "marathonctl-unstable-${version}";
  version = "2017-03-06";

  goPackagePath = "github.com/shoenig/marathonctl";
  subPackages = [ "." ];
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "shoenig";
    repo = "marathonctl";
    rev = "0867e66551fff5d81f25959baf914a8ee11a3a8b";
    sha256 = "1fcc54hwpa8s3kz4gn26mc6nrv6zjrw869331nvm47khi23gpmxw";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/shoenig/marathonctl;
    description = "CLI tool for Marathon";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
