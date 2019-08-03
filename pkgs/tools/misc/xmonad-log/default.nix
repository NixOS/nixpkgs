{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "xmonad-log-${version}";
  version = "0.1.0";

  goPackagePath = "github.com/xintron/xmonad-log";

  src = fetchFromGitHub {
    owner = "xintron";
    repo = "xmonad-log";
    rev = version;
    sha256 = "1il6v0zcjw0pfb1hjj198y94jmlcx255h422ph0f1zr7afqkzmaw";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "xmonad DBus monitoring solution";
    homepage = https://github.com/xintron/xmonad-log;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ joko ];
  };
}
