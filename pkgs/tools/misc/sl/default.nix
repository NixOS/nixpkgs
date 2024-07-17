{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "sl";
  version = "5.05";

  src = fetchFromGitHub {
    owner = "eyJhb";
    repo = "sl";
    rev = version;
    sha256 = "11a1rdgb8wagikhxgm81g80g5qsl59mv4qgsval3isykqh8729bj";
  };

  buildInputs = [ ncurses ];

  makeFlags = [ "CC:=$(CC)" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin sl
    install -Dm644 -t $out/share/man/man1 sl.1{,.ja}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Steam Locomotive runs across your terminal when you type 'sl'";
    homepage = "http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html";
    license = rec {
      shortName = "Toyoda Masashi's free software license";
      fullName = shortName;
      url = "https://github.com/eyJhb/sl/blob/master/LICENSE";
    };
    maintainers = with maintainers; [ eyjhb ];
    platforms = platforms.unix;
    mainProgram = "sl";
  };
}
