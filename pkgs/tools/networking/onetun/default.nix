{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "onetun";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "aramperes";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bggBBl2YQUncfOYIDsPgrHPwznCJQOlIOY3bbiZz7Rw=";
  };

  cargoHash = "sha256-Il/jwaQ4nu93R1fC3r6haSSF5ATSrgkv4uZmAA/RZBI=";

  meta = {
    description = "Cross-platform, user-space WireGuard port-forwarder that requires no root-access or system network configurations";
    homepage = "https://github.com/aramperes/onetun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "onetun";
  };
}
