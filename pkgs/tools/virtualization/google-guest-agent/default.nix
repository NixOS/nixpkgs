<<<<<<< HEAD
{ buildGoModule, fetchFromGitHub, lib, coreutils, makeWrapper
, google-guest-configs, google-guest-oslogin, iproute2, procps
=======
{ buildGoModule, fetchFromGitHub, fetchpatch, lib, coreutils, makeWrapper
, google-guest-configs, google-guest-oslogin, iproute2, dhcp, procps
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "guest-agent";
<<<<<<< HEAD
  version = "20230726.00";
=======
  version = "20230221.00";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "GoogleCloudPlatform";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-p+gjiaUaBBGhCVkbXrubfV/xZWvanC8ktlfIfjyUQSA=";
  };

  vendorHash = "sha256-Xw/5yHW9DRtZFC6cECLI0RncgzSGB5/Y0yjW7hz247s=";
=======
    sha256 = "sha256-AObN9vyEMJeGBmAMyUz7H0pHPtGf5I/oeDzYuZs4KpE=";
  };

  vendorHash = "sha256-ioejOtmsi0QnID3V5JxwAz399I5Jp5nHZqpzU9DjpQE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  patches = [ ./disable-etc-mutation.patch ];

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substitute ${./fix-paths.patch} fix-paths.patch \
      --subst-var out \
      --subst-var-by true "${coreutils}/bin/true"
    patch -p1 < ./fix-paths.patch
  '';

  # We don't add `shadow` here; it's added to PATH if `mutableUsers` is enabled.
<<<<<<< HEAD
  binPath = lib.makeBinPath [ google-guest-configs google-guest-oslogin iproute2 procps ];
=======
  binPath = lib.makeBinPath [ google-guest-configs google-guest-oslogin iproute2 dhcp procps ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Skip tests which require networking.
  preCheck = ''
    rm google_guest_agent/wsfc_test.go
  '';

  postInstall = ''
    mkdir -p $out/etc/systemd/system
    cp *.service $out/etc/systemd/system
    install -Dm644 instance_configs.cfg $out/etc/default/instance_configs.cfg

    wrapProgram $out/bin/google_guest_agent \
      --prefix PATH ":" "$binPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/GoogleCloudPlatform/guest-agent";
    description = "Guest Agent for Google Compute Engine";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
