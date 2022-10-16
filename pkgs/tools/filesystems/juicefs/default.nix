{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JxN8p/935k+mWkGNSKrI7jCTxcGs5TcUXcmkDjwnzZg=";
  };

  vendorSha256 = "sha256-rYyzy6UQQu8q+ei4GAEEq+JPhAAUvHcRpIzNts150OA=";

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
