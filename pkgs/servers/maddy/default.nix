{ lib, buildGoModule, fetchFromGitHub, coreutils, installShellFiles, scdoc, nixosTests }:

buildGoModule rec {
  pname = "maddy";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
    sha256 = "sha256-b85g8Eu7qWTI+ggMr7JL/2BAVbkXocpsR89P6s6TfMg=";
  };

  vendorSha256 = "sha256-kzSwqT3r6uGxq1GNzCWCn8VoCxmVtiUb23XLCpsPv/c=";

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
