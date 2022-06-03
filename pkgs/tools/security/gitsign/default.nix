{ lib, buildGoModule, fetchFromGitHub, stdenv }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tcWq+WZJLyO8lJKxV0QSDH1JKgW+9FaC9FxrSotLQag=";
  };
  vendorSha256 = "sha256-34pyHAUU1+K9qNAi7rPZIvaGAen+LrwEqLyrrzUaLbk=";

  ldflags = [ "-s" "-w" ];

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
    # Need updated macOS SDK
    # https://github.com/NixOS/nixpkgs/issues/101229
    broken = (stdenv.isDarwin && stdenv.isx86_64);
  };
}
