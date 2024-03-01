{ lib
, buildGoModule
, fetchFromGitHub
, stdenv
}:

buildGoModule rec {
  pname = "juicefs";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "juicedata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Sf68N5ZKveKM6xZEqF7Ah0KGgOx1cGZpJ2lYkUlgpI0=";
  };

  vendorHash = "sha256-ofUo/3EQPhXPNeD/3to5oFir/3eAaf9WBHR4DOzcxBQ=";

  ldflags = [ "-s" "-w" ];

  doCheck = false; # requires network access

  # we dont need the libjfs binary
  postFixup = ''
    rm $out/bin/libjfs
  '';

  postInstall = ''
    ln -s $out/bin/juicefs $out/bin/mount.juicefs
  '';

  meta = with lib; {
    description = "A distributed POSIX file system built on top of Redis and S3";
    homepage = "https://www.juicefs.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
    broken = stdenv.isDarwin;
  };
}
