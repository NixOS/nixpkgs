{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DQ3JdP1HKWORPkcP4HJ32eg6aaockZfG+FQhBJnZCFQ=";
  };

  vendorHash = "sha256-fHmLTAn4W8KMtZ1Ov4gBQTUpzHqQnipGSQs5hr1MD3w=";

  excludedPackages = [ "sdk/java/libjfs" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/juicedata/juicefs/pkg/version.version=${version}"
  ];

  doCheck = false; # requires network access

  postInstall = ''
    ln -s $out/bin/juicefs $out/bin/mount.juicefs
  '';

  meta = with lib; {
    description = "Distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
