{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  version = "2.0.0";
  name = "etcd-${version}";
  goPackagePath = "github.com/coreos/etcd";
  src = fetchFromGitHub {
    owner = "coreos";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "1s3jilzlqyh2i81pv79cgap6dfj7qrfrwcv4w9lic5ivznz413vc";
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
