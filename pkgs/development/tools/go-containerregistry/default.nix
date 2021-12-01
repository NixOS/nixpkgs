{ lib, buildGoModule, fetchFromGitHub }:

let bins = [ "crane" "gcrane" ]; in

buildGoModule rec {
  pname = "go-containerregistry";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sk3g1i4w8sh40y1ffa61ap7jsscdvnhvh09k8nznydi465csbmq";
  };
  vendorSha256 = null;

  subPackages = [ "cmd/crane" "cmd/gcrane" ];

  outputs = [ "out" ] ++ bins;

  ldflags =
    let t = "github.com/google/go-containerregistry"; in
    [ "-s" "-w" "-X ${t}/cmd/crane/cmd.Version=v${version}" "-X ${t}/pkg/v1/remote/transport.Version=${version}" ];

  postInstall =
    lib.concatStringsSep "\n" (
      map (bin: ''
        mkdir -p ''$${bin}/bin &&
        mv $out/bin/${bin} ''$${bin}/bin/ &&
        ln -s ''$${bin}/bin/${bin} $out/bin/
      '') bins
    );

  # NOTE: no tests
  doCheck = false;

  meta = with lib; {
    description = "Tools for interacting with remote images and registries including crane and gcrane";
    homepage = "https://github.com/google/go-containerregistry";
    license = licenses.apsl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
