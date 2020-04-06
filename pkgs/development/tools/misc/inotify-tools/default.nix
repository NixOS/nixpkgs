{ stdenv, autoreconfHook, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "inotify-tools";
  version = "3.20.2.2";

  src = fetchFromGitHub {
    repo = "inotify-tools";
    owner = "rvoicilas";
    rev = version;
    sha256 = "1r12bglkb0bkqff6kgxjm81hk6z20nrxq3m7iv15d4nrqf9pm7s0";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/inotify-tools/inotify-tools/commit/7ddf45158af0c1e93b02181a45c5b65a0e5bed25.patch";
      sha256 = "08imqancx8l0bg9q7xaiql1xlalmbfnpjfjshp495sjais0r6gy7";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    homepage = https://github.com/rvoicilas/inotify-tools/wiki;
    license = licenses.gpl2;
    maintainers = with maintainers; [ marcweber pSub ];
    platforms = platforms.linux;
  };
}
