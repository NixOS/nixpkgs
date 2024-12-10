{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qTJU5o0wjHu3M8zMwMm6/QTAqD2JvCg9XnxfW77MCoI=";
  };

  vendorHash = "sha256-y5ao4C24Py8NmZLZlpoz3C7TvUe5vsI74QdzQ7LAh6o=";

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
