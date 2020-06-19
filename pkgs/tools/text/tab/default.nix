{ stdenv, fetchFromBitbucket, python2 }:

stdenv.mkDerivation rec {
  version = "7.2";
  pname = "tab";

  src = fetchFromBitbucket {
    owner = "tkatchev";
    repo = pname;
    rev = version;
    sha256 = "1bm15lw0vp901dj2vsqx6yixmn7ls3brrzh1w6zgd1ksjzlm5aax";
  };

  nativeBuildInputs = [ python2 ];

  doCheck = !stdenv.isDarwin;

  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin tab
    install -Dm444 -t $out/share/doc/tab docs/*.html

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Programming language/shell calculator";
    homepage    = "https://tkatchev.bitbucket.io/tab/";
    license     = licenses.boost;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = with platforms; unix;
  };
}
