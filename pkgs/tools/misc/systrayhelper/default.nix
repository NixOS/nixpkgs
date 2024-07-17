{
  lib,
  pkg-config,
  libappindicator-gtk3,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "systrayhelper";
  version = "unstable-2021-05-20";
  rev = "da47887f050cf0f22d9348cb4493df9ffda2a229";

  src = fetchFromGitHub {
    owner = "ssbc";
    repo = "systrayhelper";
    rev = rev;
    hash = "sha256-9ejpARZghXhb3EJDvNcidg5QM8Z+P91ICGuA89ksqeA=";
  };

  vendorHash = null;

  # re date: https://github.com/NixOS/nixpkgs/pull/45997#issuecomment-418186178
  # > .. keep the derivation deterministic. Otherwise, we would have to rebuild it every time.
  ldflags = [
    "-X main.version=v${version}"
    "-X main.commit=${rev}"
    "-X main.date=nix-byrev"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    pkg-config
    libappindicator-gtk3
  ];
  buildInputs = [ libappindicator-gtk3 ];

  doCheck = false; # Display required

  meta = with lib; {
    description = "A systray utility written in go, using json over stdio for control and events";
    homepage = "https://github.com/ssbc/systrayhelper";
    maintainers = with maintainers; [ cryptix ];
    license = licenses.mit;
    # It depends on the inputs, i guess? not sure about solaris, for instance. go supports it though
    # I hope nix can figure this out?! ¯\\_(ツ)_/¯
    mainProgram = "systrayhelper";
  };
}
