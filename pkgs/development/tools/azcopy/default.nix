{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
<<<<<<< HEAD
  version = "10.20.1";
=======
  version = "10.18.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-pfbSNFKZubgebx90zL5sVva36wXS+0NQvvMxPI8kV3Y=";
=======
    sha256 = "sha256-Yy6A2lNxF3aHD6Jw/dnLt1MFiFQ9+U+cB4wVK/dWbmE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  subPackages = [ "." ];

<<<<<<< HEAD
  vendorHash = "sha256-byFroeXRMepN9RYak2++tT9IE8ZbT+0qJAyipHkE5WE=";
=======
  vendorHash = "sha256-F+tUsChcknI4j5/IM1FqMKsFmGHEKjthjzSitMPyc44=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
<<<<<<< HEAD
    maintainers = with maintainers; [ colemickens kashw2 ];
=======
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
