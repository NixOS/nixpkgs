{ stdenv, fetchFromGitHub, buildGoPackage, CoreFoundation }:

buildGoPackage rec {
  name = "tychus-${version}";
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

  buildInputs = stdenv.lib.optionals stdenv.hostPlatform.isDarwin [ CoreFoundation ];

  buildFlags = "--tags release";

  meta = {
    description = "Command line utility to live-reload your application.";
    homepage = https://github.com/devlocker/tychus;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
