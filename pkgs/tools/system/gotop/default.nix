{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotop-${version}";
  version = "1.7.1";

  goPackagePath = "github.com/cjbassi/gotop";

  src = fetchFromGitHub {
    repo = "gotop";
    owner = "cjbassi";
    rev = version;
    sha256 = "0dxnhal10kv6ypsg6mildzpz6vi1iw996q47f4rv8hvfyrffhzc9";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = https://github.com/cjbassi/gotop;
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
