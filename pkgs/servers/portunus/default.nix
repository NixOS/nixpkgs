{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libxcrypt-legacy, # TODO: switch to libxcrypt for NixOS 24.11 (cf. same note on nixos/modules/services/misc/portunus.nix)
}:

buildGoModule rec {
  pname = "portunus";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "portunus";
    rev = "v${version}";
    sha256 = "sha256-+pMMIutj+OWKZmOYH5NuA4a7aS5CD+33vAEC9bJmyfM=";
  };

  buildInputs = [ libxcrypt-legacy ];

  vendorHash = null;

  meta = with lib; {
    description = "Self-contained user/group management and authentication service";
    homepage = "https://github.com/majewsky/portunus";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ majewsky ] ++ teams.c3d2.members;
  };
}
