{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tere";
<<<<<<< HEAD
  version = "1.5.0";
=======
  version = "1.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mgunyho";
    repo = "tere";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-xqbFBRzBfTwSdkC8e85yANdVA45G6E1FYlTXP8QfVIk=";
  };

  cargoHash = "sha256-Y2Zgo/VAJxzQd2cXxyiJS5AqcVRClAuUsEogivK3EJw=";
=======
    sha256 = "sha256-gEoy7pwZxlCIPTQZVPSo5TIdmSliSSePunXO3hD3Ryo=";
  };

  cargoSha256 = "sha256-4XvVisRLSHw4jz+nUndWzS1IK2tnzmxdcgqNHHOvkQg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "A faster alternative to cd + ls";
    homepage = "https://github.com/mgunyho/tere";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
