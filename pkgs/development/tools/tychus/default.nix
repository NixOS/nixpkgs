{ lib, stdenv, fetchFromGitHub, buildGoPackage, CoreFoundation }:

buildGoPackage rec {
  pname = "tychus";
  version = "0.6.3";

  goPackagePath = "github.com/devlocker/tychus";
  goDeps = ./deps.nix;
  subPackages = [];

  src = fetchFromGitHub {
    owner = "devlocker";
    repo = "tychus";
    rev = "v${version}";
    sha256 = "02ybxjsfga89gpg0k21zmykhhnpx1vy3ny8fcwj0qsg73i11alvw";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreFoundation ];

  tags = [ "release" ];

  meta = {
    description = "Command line utility to live-reload your application";
    homepage = "https://github.com/devlocker/tychus";
    license = lib.licenses.mit;
  };
}
