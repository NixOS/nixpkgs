{ lib, buildGoModule, fetchFromGitHub, coreutils, installShellFiles, scdoc, nixosTests }:

buildGoModule rec {
  pname = "maddy";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
    sha256 = "sha256-UB9Y2nNkiN0L3NIfUqnpaJJqNuAnCYIeEyS60TnnIRs=";
  };

  vendorSha256 = "sha256-lL9hlICc9t/2v6eawG8LU6hpAKpY7raTg5l1RagewPs=";

  ldflags = [ "-s" "-w" "-X github.com/foxcpp/maddy.Version=${version}" ];

  subPackages = [ "cmd/maddy" "cmd/maddyctl" ];

  nativeBuildInputs = [ installShellFiles scdoc ];

  postInstall = ''
    for f in docs/man/*.scd; do
      local page="docs/man/$(basename "$f" .scd)"
      scdoc < "$f" > "$page"
      installManPage "$page"
    done

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
