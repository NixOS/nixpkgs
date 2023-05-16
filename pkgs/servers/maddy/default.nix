{ lib, buildGoModule, fetchFromGitHub, pam, coreutils, installShellFiles, scdoc, nixosTests }:

buildGoModule rec {
  pname = "maddy";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-EMw07yTFP0aBSuGDWivB8amuxWLFHhYV6J9faTEW5z4=";
  };

  vendorHash = "sha256-LyfkETZPkhJKN8CEivNp7Se4IBpzyAtmCM1xil4n2po=";
=======
    sha256 = "sha256-vf+jkXerdwvQhtyiOObBRxh8sYMEcgXC5vNzm5wquBs=";
  };

  vendorSha256 = "sha256-10cLNl9jWYX8XIKQkCxJ+/ymZC1YJRHUJWZQhq7zeV4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  tags = [ "libpam" ];

  ldflags = [ "-s" "-w" "-X github.com/foxcpp/maddy.Version=${version}" ];

  subPackages = [ "cmd/maddy" ];

  buildInputs = [ pam ];

  nativeBuildInputs = [ installShellFiles scdoc ];

  postInstall = ''
    for f in docs/man/*.scd; do
      local page="docs/man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

    ln -s "$out/bin/maddy" "$out/bin/maddyctl"

    mkdir -p $out/lib/systemd/system

    substitute dist/systemd/maddy.service $out/lib/systemd/system/maddy.service \
      --replace "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace "/bin/kill" "${coreutils}/bin/kill"

    substitute dist/systemd/maddy@.service $out/lib/systemd/system/maddy@.service \
      --replace "/usr/local/bin/maddy" "$out/bin/maddy" \
      --replace "/bin/kill" "${coreutils}/bin/kill"
  '';

  passthru.tests.nixos = nixosTests.maddy;

  meta = with lib; {
    description = "Composable all-in-one mail server";
    homepage = "https://maddy.email";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
