{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "pocketbase";
<<<<<<< HEAD
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = "pocketbase";
    rev = "v${version}";
    hash = "sha256-UwxE36y99vW/45Lnkm5qaevEToxIVs73YUJVDtr8ziA=";
  };

  vendorHash = "sha256-vb0957zO27OgrSTUiAt+vuo9NKM5ftz8mbFf613l0eM=";
=======
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "pocketbase";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9LIOBfNOa+u7yLL7iWb/e7c8ZSiyjukqaY0ifVR2iSs=";
  };

  vendorHash = "sha256-LFIJClPByaLXtsBOk7SjpJlIuQhWbVIs6H4PXhd7oyo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # This is the released subpackage from upstream repo
  subPackages = [ "examples/base" ];

  CGO_ENABLED = 0;

  # Upstream build instructions
  ldflags = [
    "-s"
    "-w"
    "-X github.com/pocketbase/pocketbase.Version=${version}"
  ];

  postInstall = ''
    mv $out/bin/base $out/bin/pocketbase
  '';

  meta = with lib; {
    description = "Open Source realtime backend in 1 file";
    homepage = "https://github.com/pocketbase/pocketbase";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ dit7ya thilobillerbeck ];
=======
    maintainers = with maintainers; [ dit7ya ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
