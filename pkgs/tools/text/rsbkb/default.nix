<<<<<<< HEAD
{ lib
, fetchFromGitHub
, rustPlatform
, enableAppletSymlinks ? true
=======
{ lib,
  fetchFromGitHub,
  rustPlatform,
  enableAppletSymlinks ? true,
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "rsbkb";
<<<<<<< HEAD
  version = "1.2";
=======
  version = "1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "trou";
    repo = "rsbkb";
    rev = "release-${version}";
<<<<<<< HEAD
    hash = "sha256-Y6YTjEbefNUPcl6rNYWVZLGZYTUPr5pvfLabS+zDWqA=";
  };

  cargoHash = "sha256-RMX+ZdPaqtqRJvhHFJJrPZnBGwQwZSCXNg1oNo+v2+8=";

  # Setup symlinks for all the utilities,
  # busybox style
  postInstall = lib.optionalString enableAppletSymlinks ''
    cd $out/bin || exit 1
    path="$(realpath --canonicalize-missing ./rsbkb)"
    for i in $(./rsbkb list) ; do ln -s $path $i ; done
  '';
=======
    hash = "sha256-SqjeH0eOo+upSfPWh2IW75p1VHMqmzAbCchDrXhvMxs=";
  };
  cargoSha256 = "N3Xlw2JzTjqWLiVNCZaomsWQl330kGVlwdz4Gf05TGU=";

  # Setup symlinks for all the utilities,
  # busybox style
  postInstall = lib.optionalString enableAppletSymlinks
    ''
    cd $out/bin || exit 1
    path="$(realpath --canonicalize-missing ./rsbkb)"
    for i in $(./rsbkb list) ; do ln -s $path $i ; done
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Command line tools to encode/decode things";
    homepage = "https://github.com/trou/rsbkb";
    changelog = "https://github.com/trou/rsbkb/releases/tag/release-${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
