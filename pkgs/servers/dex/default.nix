{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "dex";
<<<<<<< HEAD
  version = "2.37.0";
=======
  version = "2.36.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dexidp";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-2u9UHummUpPljTzPNCQfHwYVeWgDOGLcGx10aVHUAZM=";
  };

  vendorHash = "sha256-sSn3qpbo04DjyPD+Ogx9JUdJ/++fNYb0bAmudQjchQ0=";
=======
    sha256 = "sha256-EIkK+X08FJKTFU4V19cGSH1yGesUfS7AibQ3zGUFyWI=";
  };

  vendorHash = "sha256-Rsz7UnBlZdPRTrq3nfFaSVwok8wLDtd6aT1sEK+++vg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [
    "cmd/dex"
  ];

  ldflags = [
    "-w" "-s" "-X github.com/dexidp/dex/version.Version=${src.rev}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r $src/web $out/share/web
  '';

  passthru.tests = { inherit (nixosTests) dex-oidc; };

  meta = with lib; {
    description = "OpenID Connect and OAuth2 identity provider with pluggable connectors";
    homepage = "https://github.com/dexidp/dex";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley techknowlogick ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
