{ lib, buildGo119Module, fetchFromGitHub }:

buildGo119Module rec {
  pname = "spire";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.7.0";
>>>>>>> 55f04c3bac6 (spire: 1.1.2 -> 1.7.0)

  outputs = [ "out" "agent" "server" ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-LK73RGSTwGhCXOglsqK8RAAldovRzliE78vi2ilTSrw=";
  };

  vendorSha256 = "sha256-am8ZTUX8Vph1Eg013NObMiSVeupS2hlHdpZ/1mO27dY=";
=======
    sha256 = "sha256-aJ9T8OUsHNeWV05MWLet35V0YFyD7QoiExN6PTmHs3w=";
  };

  vendorSha256 = "sha256-4KJysqByDVuK2OU/+sGtpXtSJe4YkVe4OhRyn9tkgsg=";
>>>>>>> 55f04c3bac6 (spire: 1.1.2 -> 1.7.0)

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
    changelog = "https://github.com/spiffe/spire/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer fkautz ];
  };
}
