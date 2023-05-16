{ lib
, buildGoModule
, fetchFromGitHub
, nix
, makeWrapper
, fetchpatch
}:

<<<<<<< HEAD
buildGoModule {
  pname = "nc4nix";
  version = "unstable-2023-06-06";
=======
buildGoModule rec {
  pname = "nc4nix";
  version = "unstable-2022-12-07";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "helsinki-systems";
    repo = "nc4nix";
<<<<<<< HEAD
    rev = "3e015450726533770fd00e2771530cbe90f40517";
    sha256 = "sha256-i3lx5Q+EswtimdRMZ0OPMWh01kBK9q+UI1pY6j/ZhuY=";
=======
    rev = "c556a596b1d40ff69b71adab257ec5ae51ba4df1";
    sha256 = "sha256-EIPCMiVTf0ryXRMRGhepORaOlimt3/funvUdORRbVa8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Switch hash calculation method
<<<<<<< HEAD
    # https://github.com/helsinki-systems/nc4nix/pull/3
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/commit/a7bca4793cc12e87d381f12f6f8c00ae2ca02893.patch";
      sha256 = "sha256-0JxyhSQLtlgLtsMv82wMjQHGdmOoQ2dcPPNAw2cFByE=";
      name = "switch_hash_calculation_method.patch";
    })

    # Fix invalid entries (pre-releases of apps are not to be taken into account,
    # but if only pre-releases are compatible with a given Nextcloud version,
    # invalid entries are generated)
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/commit/c48131b5ca382585fd3294d51d59acc1e92fadb1.patch";
      sha256 = "sha256-/zc3Smjd6CksC5wUvoB6uAyTzPcIgqimb+zASIuTft0=";
      excludes = [ "25.json" "26.json" "27.json" ];
    })
  ];

  vendorHash = "sha256-uhINWxFny/OY7M2vV3ehFzP90J6Z8cn5IZHWOuEg91M=";
=======
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/commit/88c182fbdddef148e086fa86438dcd72208efd75.patch";
      sha256 = "sha256-zAF0+t9wHrKhhyD0+/d58BiaavLHfxO8X5J6vNlEWx0=";
      name = "switch_hash_calculation_method.patch";
    })
     # Add package selection command line argument
    (fetchpatch {
      url = "https://github.com/helsinki-systems/nc4nix/pull/2/commits/449eec89538df4e92106d06046831202eb84a1db.patch";
      sha256 = "sha256-qAAbR1G748+2vwwfAhpe8luVEIKNGifqXqTV9QqaUFc=";
      name = "add_package_selection_command_line_arg.patch";
    })
  ];

  vendorSha256 = "sha256-uhINWxFny/OY7M2vV3ehFzP90J6Z8cn5IZHWOuEg91M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

 nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    # Depends on nix-prefetch-url
    wrapProgram $out/bin/nc4nix \
      --prefix PATH : ${lib.makeBinPath [ nix ]}
  '';

  meta = with lib; {
    description = "Packaging helper for Nextcloud apps";
    homepage = "https://github.com/helsinki-systems/nc4nix";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };
}

