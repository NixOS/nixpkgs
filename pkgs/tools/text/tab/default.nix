{ stdenv, fetchFromBitbucket, python2 }:

stdenv.mkDerivation rec {
  version = "7.1";
  pname = "tab";

  src = fetchFromBitbucket {
    owner = "tkatchev";
    repo = pname;
    rev = version;
    sha256 = "049wx24b4v8alhvc05z7snyzaf6fk9w2npc4kklp366yjl1l4qbb";
  };

  nativeBuildInputs = [ python2 ];

  doCheck = true;

  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp tab $out/bin

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Programming language/shell calculator";
    homepage    = https://tkatchev.bitbucket.io/tab/;
    license     = licenses.boost;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = with platforms; linux;
  };
}
