{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jfrog-cli";
  version = "1.43.2";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    sha256 = "0gc8a4cpzcpa3mrqzhba4xx0316z030q71bpxlslivxg5xpvgq0v";
  };

  CGO_ENABLED = 0;

  vendorSha256 = "1imlc8vmhph9gy4c9xyr2czfyh42p9crh37h5axc5939lnn4x9z6";

  # Extracted from build/build.sh.
  buildFlagsArray = [
    "-ldflags=-s -w -extldflags '-static'"
  ];

  # Most of them seem to require network access.
  doCheck = false;

  postInstall = ''
    mv $out/bin/jfrog-cli $out/bin/jfrog
    ln -s $out/bin/jfrog $out/bin/jfrog-cli
  '';

  meta = with lib; {
    description = "A client that provides a simple interface that automates access to the JFrog products";
    homepage = "https://github.com/jfrog/jfrog-cli";
    license = licenses.asl20;
    maintainers = [ teams.deshaw.members ];
  };
}
