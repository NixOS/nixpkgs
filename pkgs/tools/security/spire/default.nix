{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spire";
  version = "1.2.0";

  outputs = [ "out" "agent" "server" ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "01ph9jzh18bnidrsbnnxm3gxh0cgfllnjvf7a5haqz51lm6a9pny";
  };

  vendorSha256 = "1fd1k5by4wcjmzfgi3gnrwnb38b0wa3w67kzjlx8s0nwapyfgx0b";

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
    homepage = "https://github.com/spiffe/spire";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer fkautz ];
  };
}
