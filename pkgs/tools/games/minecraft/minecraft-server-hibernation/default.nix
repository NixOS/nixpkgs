{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "minecraft-server-hibernation";
  version = "2.4.10";

  src = fetchFromGitHub {
    owner = "gekware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hflPVO+gqHr0jDrhWzd7t/E6WsswiMKMHCkTUK4E05k=";
  };

  vendorHash = "sha256-W6P7wz1FGL6Os1zmmqWJ7/sO8zizfnwg+TMiFWGHIOM=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Autostart and stop minecraft-server when players join/leave";
    homepage = "https://github.com/gekware/minecraft-server-hibernation";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ squarepear ];
  };
}
