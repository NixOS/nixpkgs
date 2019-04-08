{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "sl-${version}";
  version = "5.04";

  src = fetchFromGitHub {
    owner = "eyJhb";
    repo = "sl";
    rev = version;
    sha256 = "029lv6vw39c7gj8bkfyqs8q4g32174vbmghhhgfk8wrhnxq60qn7";
  };

  buildInputs = [ ncurses ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin sl
    install -Dm644 -t $out/share/man/man1 sl.1{,.ja}

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Steam Locomotive runs across your terminal when you type 'sl'";
    homepage = http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html;
    license = rec {
      shortName = "Toyoda Masashi's free software license";
      fullName = shortName;
      url = https://github.com/eyJhb/sl/blob/master/LICENSE;
    };
    maintainers = with maintainers; [ eyjhb ];
    platforms = platforms.unix;
  };
}
