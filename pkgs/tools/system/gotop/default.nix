{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gotop";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "xxxserxxx";
    repo = pname;
    rev = "v${version}";
    sha256 = "10qfzmq1wdgpvv319khzicalix1x4fqava0wry3bzz84k5c9dabs";
  };

  runVend = true;
  vendorSha256 = "09vdhdgj74ifdhl6rmxddkvk7ls26jn8gswzcxf9389zkjzi7822";

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with stdenv.lib; {
    description = "A terminal based graphical activity monitor inspired by gtop and vtop";
    homepage = "https://github.com/xxxserxxx/gotop";
    license = licenses.agpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.unix;
  };
}
