{ writeShellScript
, lib
, git
, nix-update
}:

writeShellScript "update-esphome" ''
  PATH=${lib.makeBinPath [ git nix-update ]}

  nix-update esphome.dashboard
  nix-update esphome
''
