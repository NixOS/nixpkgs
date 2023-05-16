{ fetchFromGitHub
, installShellFiles
, lib
, rustPlatform
, scdoc
}:

rustPlatform.buildRustPackage rec {
  pname = "uair";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "v0.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "metent";
    repo = pname;
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-cxSNBxs6ixbjWMUYzOnwI+vavkfyaQx3/OmVdTCr7M0=";
  };

  cargoHash = "sha256-cDIF4RvJ7K6t18GPgiRV6NDoD/x3II/3wCHW3KK2/os=";
=======
    rev = version;
    hash = "sha256-qxfdKU3SFGVpp3OG0m+0qDvs5cB2bAaTF8+K6zwXRnI=";
  };

  cargoHash = "sha256-XmEbXzpynkUPXywaf4wPcWq9zf3gNOHkcVr2jz3WNnc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles scdoc ];

  preFixup = ''
    scdoc < docs/uair.1.scd > docs/uair.1
    scdoc < docs/uair.5.scd > docs/uair.5
    scdoc < docs/uairctl.1.scd > docs/uairctl.1

    installManPage docs/*.[1-9]
  '';

  meta = with lib; {
    description = "An extensible pomodoro timer";
    homepage = "https://github.com/metent/uair";
    license = licenses.mit;
    maintainers = with maintainers; [ thled ];
  };
}
