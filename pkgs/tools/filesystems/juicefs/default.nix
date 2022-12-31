{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zGVOodjNPH/vCIBEjXo3MTg8McybakMv7tg0Y9ahasU=";
  };

  vendorSha256 = "sha256-YzFGqn9r06TEMiKuuUbUkoacFpsAOPopX9MNB4mlTIM=";

  ldflags = [ "-s" "-w" ];

  doCheck = false; # requires network access

  # we dont need the libjfs binary
  postFixup = ''
    rm $out/bin/libjfs
  '';

  meta = with lib; {
    description = "A distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    broken = stdenv.isDarwin;
  };
}
