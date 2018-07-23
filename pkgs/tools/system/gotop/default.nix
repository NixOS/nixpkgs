{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotop-${version}";
  version = "1.2.9";

  goPackagePath = "github.com/cjbassi/gotop";

  src = fetchFromGitHub {
    repo = "gotop";
    owner = "cjbassi";
    rev = version;
    sha256 = "07s2f04yhc79vqr1gdh2v974kpn7flp4slnp99mavpa331lv9q8a";
  };

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = https://github.com/cjbassi/gotop;
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
