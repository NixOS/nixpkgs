{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "ioping";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "koct9i";
    repo = "ioping";
    rev = "v${version}";
    sha256 = "10bv36bqga8sdifxzywzzpjil7vmy62psirz7jbvlsq1bw71aiid";
  };

  patches = [
    # add netdata support: https://github.com/koct9i/ioping/pull/41
    (fetchpatch {
      url = "https://github.com/koct9i/ioping/commit/e7b818457ddb952cbcc13ae732ba0328f6eb73b3.patch";
      sha256 = "122ivp4rqsnjszjfn33z8li6glcjhy7689bgipi8cgs5q55j99gf";
    })
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Disk I/O latency measuring tool";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
    license = licenses.gpl3Plus;
    homepage = "https://github.com/koct9i/ioping";
    mainProgram = "ioping";
  };
}
