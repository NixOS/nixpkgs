{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "2.0.9";
  name = "etcd-${version}";
  goPackagePath = "github.com/coreos/etcd";
  src = fetchFromGitHub {
    owner = "coreos";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "0da5jcm3z6r3cyh709hdn6i0mfkkwj82w3df0j34g5fxwf9kxx2q";
  };

  subPackages = [ "./" ];

  meta = with lib; {
    description = "A highly-available key value store for shared configuration and service discovery";
    homepage = http://coreos.com/using-coreos/etcd/;
    license = licenses.asl20;
    maintainers = with maintainers; [ cstrahan ];
    platforms = platforms.unix;
  };
}
