{ lib, buildGoPackage, fetchFromGitHub, perl
, go-bindata, libxml2, protobuf3_1, libpcap, pkgconfig, go-protobuf }:

buildGoPackage rec {
  pname = "skydive";
  version = "0.17.0";
  goPackagePath = "github.com/skydive-project/skydive";

  src = fetchFromGitHub {
    owner = "skydive-project";
    repo = "skydive";
    rev = "v${version}";
    sha256 = "03y26imiib2v9icrgwlamzsrx3ph6vn582051vdk1x9ar80xp4dv";
  };

  patchPhase = ''
    substituteInPlace Makefile \
      --replace ".proto: builddep" ".proto: " \
      --replace ".bindata: builddep" ".bindata: "
  '';

  buildInputs = [ perl go-bindata go-protobuf libxml2 protobuf3_1 libpcap pkgconfig ];
  goDeps = ./deps.nix;

  preBuild = ''
    make -C go/src/github.com/skydive-project/skydive genlocalfiles VERSION=${version}
  '';

  preInstall = ''
    mkdir -p $out/share/skydive
    cp go/src/github.com/skydive-project/skydive/etc/skydive.yml.default $out/share/skydive/
  '';

  postInstall = ''
    rm $bin/bin/snort
  '';

  meta = {
    homepage = http://skydive.network;
    description = "A real-time network analyzer";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.lewo ];
  };
}
