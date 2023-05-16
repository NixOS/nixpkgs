{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "spire";
<<<<<<< HEAD
  version = "1.7.2";
=======
  version = "1.6.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "agent" "server" ];

  src = fetchFromGitHub {
    owner = "spiffe";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-3D7TlL4SulLAqpVIMJ4Yl2OWnNsMYMLVJqgGhOYMiio=";
  };

  vendorHash = "sha256-Vct++sjkkosBOY0Uho58MHSQoL5121kYbQTf1j+HFUk=";
=======
    sha256 = "sha256-l+qDRcSZoCMfG20uE7xit2xhwwxVSBByqrRJcAH/WH4=";
  };

  vendorHash = "sha256-th6HoMn5PjDFMnXwjNVC0Ngqtyu+XB1SFyrd5j8ZI8k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
