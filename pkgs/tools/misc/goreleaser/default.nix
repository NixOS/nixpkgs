{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.147.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pzbwjqnb2l1845dqmx5s2xyxv7088yz2888bjwm0qs8pm1l6spi";
  };

  vendorSha256 = "1qwggbgfvgx1anh55jx2lj0x59h5j3wixb8r2ylaynrrxx1b167w";

  buildFlagsArray = [
    "-ldflags="
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  # tests expect the source files to be a build repo
  doCheck = false;

  meta = with lib; {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with maintainers; [ c0deaddict endocrimes sarcasticadmin ];
    license = licenses.mit;
  };
}
