{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spire";
  version = "1.9.6";

  outputs = [ "out" "agent" "server" ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wubrZJBPLA83VB57UVKLuh2cmyXHouwN4BVPiHFl+1s=";
  };

  vendorHash = "sha256-tx0zIr9rXuOvt+77Sp6dIdtN21fDX5FdnTxGpHWo7+A=";

  subPackages = [ "cmd/spire-agent" "cmd/spire-server" ];

  # Usually either the agent or server is needed for a given use case, but not both
  postInstall = ''
    mkdir -vp $agent/bin $server/bin
    mv -v $out/bin/spire-agent $agent/bin/
    mv -v $out/bin/spire-server $server/bin/

    ln -vs $agent/bin/spire-agent $out/bin/spire-agent
    ln -vs $server/bin/spire-server $out/bin/spire-server
  '';

  meta = with lib; {
    description = "SPIFFE Runtime Environment";
    homepage = "https://github.com/spiffe/spire";
    changelog = "https://github.com/spiffe/spire/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer fkautz ];
  };
}
