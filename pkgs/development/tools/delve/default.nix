{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "delve-${version}";
  version = "0.11.0-alpha";

  goPackagePath = "github.com/derekparker/delve";
  excludedPackages = "_fixtures";

  src = fetchFromGitHub {
    owner = "derekparker";
    repo = "delve";
    rev = "v${version}";
    sha256 = "10axxlvqpa6gx6pz2djp8bb08b83rdj1pavay0nqdd2crsb6rvgd";
  };

  meta = {
    description = "debugger for the Go programming language";
    homepage = "https://github.com/derekparker/delve";
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.mit;
  };
}
