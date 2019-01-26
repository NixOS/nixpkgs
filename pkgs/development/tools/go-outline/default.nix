{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-outline-${version}";
  version = "unstable-2017-08-04";
  rev = "9e9d089bb61a5ce4f8e0c8d8dc5b4e41b0e02a48";

  goPackagePath = "github.com/ramya-rao-a/go-outline";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    inherit rev;
    owner = "ramya-rao-a";
    repo = "go-outline";
    sha256 = "0kbkv4d6q9w0d41m00sqdm10l0sg56mv8y6rmidqs152mm2w13x0";
  };

  meta = {
    description = "Utility to extract JSON representation of declarations from a Go source file.";
    homepage = https://github.com/ramya-rao-a/go-outline;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
