{ stdenv, buildGoPackage, fetchFromGitHub }:

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

  goDeps = ./deps.nix;

  CGO_ENABLED = 1;
  buildFlags = [ "-ldflags" ];

  meta = with stdenv.lib; {
    homepage = "https://www.teleconsole.com/";
    description = "Share your terminal session with people you trust";
    license = licenses.asl20;
    platforms = platforms.all;
    # Builds for Aarch64 not possible in the current release due to
    # incompatibilities further up the dependency chain.
    # See:
    #  - https://github.com/gravitational/teleport/issues/679
    #  - https://github.com/kr/pty/issues/27
    broken = stdenv.isAarch64;
    maintainers = [ maintainers.kimburgess ];
  };
}
