{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "go-md2man";
  version = "2.0.0";

  goPackagePath = "github.com/cpuguy83/go-md2man";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "0r1f7v475dxxgzqci1mxfliwadcrk86ippflx9n411325l4g3ghv";
  };

  meta = with lib; {
    description = "Go tool to convert markdown to man pages";
    license = licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
