{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bez9wwAPDyYYECDwW9CB/ACTGUJl6PW3YiipIGY0Zbo=";
  };

  vendorHash = "sha256-dsKNFIXcSeYUyh1TO1h1Ze3jS97pdhn2eU9hHjTARCo=";

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
