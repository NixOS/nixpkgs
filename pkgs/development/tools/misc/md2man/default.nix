{ stdenv, lib, buildGoPackage, go, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  name = "go-md2man-${version}";
  version = "1.0.6";

  goPackagePath = "github.com/cpuguy83/go-md2man";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "1rm3zjrmfpzy0l3qp02xmd5pqzl77pdql9pbxhl0k1qw2vfzrjv6";
  };

  meta = {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = https://github.com/cpuguy83/go-md2man;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
