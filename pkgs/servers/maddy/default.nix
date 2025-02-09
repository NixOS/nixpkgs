{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, pam
, coreutils
, installShellFiles
, scdoc
, nixosTests
}:

buildGoModule rec {
  pname = "maddy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "foxcpp";
    repo = "maddy";
    rev = "v${version}";
    sha256 = "sha256-EMw07yTFP0aBSuGDWivB8amuxWLFHhYV6J9faTEW5z4=";
  };

  vendorHash = "sha256-LyfkETZPkhJKN8CEivNp7Se4IBpzyAtmCM1xil4n2po=";

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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=strict-prototypes";

  passthru.tests.nixos = nixosTests.maddy;

  meta = with lib; {
    description = "Composable all-in-one mail server";
    homepage = "https://maddy.email";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
  };
}
