{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "etcd";
  version = "3.4.14";

  deleteVendor = true;
  vendorSha256 = "0jlnh4789xa2dhbyp33k9r278kc588ykggamnnfqivb27s2646bc";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
    sha256 = "0s6xwc8yczjdf6xysb6m0pp31hxjqdqjw24bliq08094jprhj31f";
  };

  buildPhase = ''
    patchShebangs .
    ./build
    ./functional/build
  '';

  installPhase = ''
    install -Dm755 bin/* bin/functional/cmd/* -t $out/bin
  '';

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
    maintainers = with maintainers; [ offline zowoq ];
    platforms = platforms.unix;
  };
}
