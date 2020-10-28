{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "snooze";
  version = "0.4";
  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "snooze";
    rev = "v${version}";
    sha256 = "0a114brvvjf6vl7grviv0gd6gmikr447m8kq1wilp4yj51sfyxa9";
  };
  makeFlags = [ "DESTDIR=$(out)" "PREFIX=/" ];

  meta = with stdenv.lib; {
    description = "Tool for waiting until a particular time and then running a command";
    maintainers = with maintainers; [ kaction ];
    license = licenses.cc0;
    platforms = platforms.linux;
  };
}
