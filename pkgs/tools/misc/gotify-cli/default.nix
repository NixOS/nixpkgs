{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "131gs6xzfggnrzq5jgyky23zvcmhx3q3hd17xvqxd02s2i9x1mg4";
  };

  vendorSha256 = "1lhhsf944gm1p6qxn05g2s3hdnra5dggj7pdrdq6qr6r2xg7f5qh";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "A command line interface for pushing messages to gotify/server.";
    maintainers = with maintainers; [ ma27 ];
  };
}
