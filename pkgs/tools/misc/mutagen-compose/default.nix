<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.17.2";
=======
{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.16.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-FEUVRDGVYYpgNSOSSR9hyUyz9mP8B8qWy3MnTtuE3fQ=";
  };

  vendorHash = "sha256-u4vRQjqBSsugEcBzteV7yOTizbXGpCH+M/zAvdWusK0=";
=======
    sha256 = "sha256-Rn3aXwez/WUGpuRvA6lkuECchpYek8KDMh6xzZOV9v0=";
  };

  vendorHash = "sha256-EkLeB2zUJkKCWsJxMiYHSDgr0/8X24MT0Jp0nuYebds=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

<<<<<<< HEAD
  tags = [ "mutagencompose" ];

  meta = with lib; {
=======
  meta = with lib; {
    broken = stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
  };
}
