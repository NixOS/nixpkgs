{ stdenv, buildGoPackage, fetchFromGitHub, pam }:

# Don't use this for anything important yet!

buildGoPackage rec {
  pname = "fscrypt";
  version = "unstable-2019-08-29";

  goPackagePath = "github.com/google/fscrypt";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "google";
    repo = "fscrypt";
    rev = "8a3acda2011e9a080ee792c1e11646e6118a4930";
    sha256 = "17h6r5lqiz0cw9vsixv48a1p78nd7bs1kncg6p4lfagl7kr5hpls";
  };

  buildInputs = [ pam ];

  meta = with stdenv.lib; {
    description =
      "A high-level tool for the management of Linux filesystem encryption";
    longDescription = ''
      This tool manages metadata, key generation, key wrapping, PAM integration,
      and provides a uniform interface for creating and modifying encrypted
      directories.
    '';
    inherit (src.meta) homepage;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
