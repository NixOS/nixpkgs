<<<<<<< HEAD
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.5.1";
=======
{ lib, rustPlatform, fetchFromGitHub, pkg-config, libXrandr, libX11 }:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-sBstFz7cYfwVQpDZeC3wPjzbKU5zQzmnhiWNqiCda1k=";
  };

  cargoSha256 = "sha256-P6riJgnEe+bNP3cUKNCfIkgKM44XGYSDADnU6w7CFDA=";
=======
    sha256 = "sha256-fcb+eZXzpuEPFSZexbgDpoBX85gsiIqPlcPXruNGenk=";
  };

  cargoSha256 = "sha256-n5HPl2h0fr0MyGBivNVrrs23HAllIYtwaw1aaKWHCe4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libXrandr libX11 ];

  # build script tries to run git to get the current tag
  postPatch = ''
    echo "fn main() {}" > build.rs
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ figsoda lumi novenary ];
=======
    maintainers = with maintainers; [ figsoda lumi ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
