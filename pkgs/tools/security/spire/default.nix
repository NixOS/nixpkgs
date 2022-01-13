{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spire";
  version = "1.1.2";

  outputs = [ "out" "agent" "server" ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MX2kbdLj72S2WBceUW/3ps34Bcsf/VArK8RN4r13wQY=";
  };

  vendorSha256 = "sha256-ZRcXMNKhNY3W5fV9q/V7xsnODoG6KWHrzpWte9hx/Ms=";

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
    description = "The SPIFFE Runtime Environment";
    homepage = "github.com/spiffe/spire";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
