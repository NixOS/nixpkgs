{ lib, stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "teleconsole";
  version = "0.4.0";

  goPackagePath = "github.com/gravitational/teleconsole";

  src = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleconsole";
    rev = version;
    sha256 = "01552422n0bj1iaaw6pvg9l1qr66r69sdsngxbcdjn1xh3mj74sm";
  };

  srcTeleport = fetchFromGitHub {
    owner = "gravitational";
    repo = "teleport";
    rev = "2cb40abd8ea8fb2915304ea4888b5b9f3e5bc223";
    sha256 = "1xw3bfnjbj88x465snwwzn4bmpmzmsrq9r0pkj388qwvfrclgnfk";
  };

  preBuild = ''
    cp -r ${srcTeleport} ./go/src/github.com/gravitational/teleport
  '';

  CGO_ENABLED = 1;

  meta = with lib; {
    homepage = "https://www.teleconsole.com/";
    description = "Share your terminal session with people you trust";
    license = licenses.asl20;
    # Builds for Aarch64 not possible in the current release due to
    # incompatibilities further up the dependency chain.
    # See:
    #  - https://github.com/gravitational/teleport/issues/679
    #  - https://github.com/kr/pty/issues/27
    broken = stdenv.isAarch64;
    maintainers = [ maintainers.kimburgess ];
  };
}
