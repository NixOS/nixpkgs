{ lib, pkg-config, libappindicator-gtk3, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "systrayhelper";
  version = "0.0.5";
  rev = "ded1f2ed4d30f6ca2c89a13db0bd3046c6d6d0f9";

  goPackagePath = "github.com/ssbc/systrayhelper";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "ssbc";
    repo = "systrayhelper";
    sha256 = "0bn3nf43m89qmh8ds5vmv0phgdz32idz1zisr47jmvqm2ky1a45s";
  };

  # re date: https://github.com/NixOS/nixpkgs/pull/45997#issuecomment-418186178
  # > .. keep the derivation deterministic. Otherwise, we would have to rebuild it every time.
  ldflags = [
    "-X main.version=v${version}"
    "-X main.commit=${rev}"
    "-X main.date=nix-byrev"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ pkg-config libappindicator-gtk3 ];
  buildInputs = [ libappindicator-gtk3 ];

  meta = with lib; {
    description = "A systray utility written in go, using json over stdio for control and events";
    homepage    = "https://github.com/ssbc/systrayhelper";
    maintainers = with maintainers; [ cryptix ];
    license     = licenses.mit;
    # It depends on the inputs, i guess? not sure about solaris, for instance. go supports it though
    # I hope nix can figure this out?! ¯\\_(ツ)_/¯
  };
}
