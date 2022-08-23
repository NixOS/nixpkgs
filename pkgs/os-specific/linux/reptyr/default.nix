{ stdenv, lib, fetchFromGitHub, python2 }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "reptyr";

  src = fetchFromGitHub {
    owner = "nelhage";
    repo = "reptyr";
    rev = "reptyr-${version}";
    sha256 = "sha256-gM3aMEqk71RWUN1NxByd21tIzp6PmJ54Cqrh5MsjHtI=";
  };

  makeFlags = [ "PREFIX=" "DESTDIR=$(out)" ];

  checkInputs = [ (python2.withPackages (p: [ p.pexpect ])) ];
  doCheck = true;

  meta = {
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "i686-freebsd"
      "x86_64-freebsd"
      "armv5tel-linux"
      "armv6l-linux"
      "armv7l-linux"
      "aarch64-linux"
      "riscv64-linux"
    ];
    maintainers = with lib.maintainers; [raskin];
    license = lib.licenses.mit;
    description = "Reparent a running program to a new terminal";
    homepage = "https://github.com/nelhage/reptyr";
  };
}
