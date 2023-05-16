<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, symlinkJoin, nixosTests }:

let
  version = "3.5.9";
=======
{ lib, buildGoModule, fetchFromGitHub, symlinkJoin }:

let
  version = "3.5.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "etcd-io";
    repo = "etcd";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Vp8U49fp0FowIuSSvbrMWjAKG2oDO1o0qO4izSnTR3U=";
=======
    hash = "sha256-VgWY622RJ8f4yA6TRC5IvatVFw2CP5lN3QBS3Xaevbc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = "https://etcd.io/";
<<<<<<< HEAD
    maintainers = with maintainers; [ offline endocrimes ];
=======
    maintainers = with maintainers; [ offline zowoq endocrimes ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.darwin ++ platforms.linux;
  };

  etcdserver = buildGoModule rec {
    pname = "etcdserver";

    inherit CGO_ENABLED meta src version;

<<<<<<< HEAD
    vendorHash = "sha256-vu5VKHnDbvxSd8qpIFy0bA88IIXLaQ5S8dVUJEwnKJA=";
=======
    vendorHash = "sha256-w/aWrQF/PAWTGMFUcpHiiDef6cvLLdYP06iwBdxrGkQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    modRoot = "./server";

    preInstall = ''
      mv $GOPATH/bin/{server,etcd}
    '';

    # We set the GitSHA to `GitNotFound` to match official build scripts when
    # git is unavailable. This is to avoid doing a full Git Checkout of etcd.
    # User facing version numbers are still available in the binary, just not
    # the sha it was built from.
    ldflags = [ "-X go.etcd.io/etcd/api/v3/version.GitSHA=GitNotFound" ];
  };

  etcdutl = buildGoModule rec {
    pname = "etcdutl";

    inherit CGO_ENABLED meta src version;

<<<<<<< HEAD
    vendorHash = "sha256-i60rKCmbEXkdFOZk2dTbG5EtYKb5eCBSyMcsTtnvATs=";
=======
    vendorHash = "sha256-Bq5vOZCflLDAhhmwSww9JCahfL/JHKa3ZT4cwNXzW90=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    modRoot = "./etcdutl";
  };

  etcdctl = buildGoModule rec {
    pname = "etcdctl";

    inherit CGO_ENABLED meta src version;

<<<<<<< HEAD
    vendorHash = "sha256-awl/4kuOjspMVEwfANWK0oi3RId6ERsFkdluiRaaXlA=";
=======
    vendorHash = "sha256-KUr0SrfuE5sh54THdvJwuMO/U6O+civ6onEPzNGqf18=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    modRoot = "./etcdctl";
  };
in
symlinkJoin {
  name = "etcd-${version}";

  inherit meta version;

<<<<<<< HEAD
  passthru = {
    inherit etcdserver etcdutl etcdctl;
    tests = { inherit (nixosTests) etcd etcd-cluster; };
  };
=======
  passthru = { inherit etcdserver etcdutl etcdctl; };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  paths = [
    etcdserver
    etcdutl
    etcdctl
  ];
}
