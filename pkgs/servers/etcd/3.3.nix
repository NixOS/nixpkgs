<<<<<<< HEAD
{ lib, buildGoPackage, fetchFromGitHub, stdenv }:
=======
{ lib, buildGoPackage, fetchFromGitHub, nixosTests, stdenv }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

buildGoPackage rec {
  pname = "etcd";
  version = "3.3.27";

  goPackagePath = "github.com/coreos/etcd";

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "sha256-zO+gwzaTgeFHhlkY/3AvRTEA4Yltlp+NqdlDe4dLJYg=";
  };

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    ./build
    ./functional/build
  '';

  installPhase = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

<<<<<<< HEAD
=======
  passthru.tests = { inherit (nixosTests) etcd etcd-cluster; };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
<<<<<<< HEAD
    maintainers = with maintainers; [ offline ];
    broken = stdenv.isDarwin; # outdated golang.org/x/sys
    knownVulnerabilities = [ "CVE-2023-32082" ];
=======
    maintainers = with maintainers; [ offline zowoq ];
    broken = stdenv.isDarwin; # outdated golang.org/x/sys
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
