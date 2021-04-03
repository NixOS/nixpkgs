{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "dapr";
  version = "1.0.1";

  vendorSha256 = "13fb6fdjqrsl74569nh2l7x9w7w61bcvkksj410s2f85bicc29rf";

  src = fetchFromGitHub {
    sha256 = "15zz212sm83l6l7npislixxn23fg190b44bfxnrjrlyjbz370kch";

    owner = "dapr";
    repo = "cli";
    rev = "v${version}";
  };

  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr
  '';

  meta = with lib; {
    homepage = "https://dapr.io";
    description = "A CLI for managing Dapr, the distributed application runtime";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
