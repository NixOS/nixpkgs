{ stdenv, fetchFromBitbucket, python2 }:

stdenv.mkDerivation rec {
  version = "7.1";
  pname = "tab";
  name = "${pname}-${version}";

  src = fetchFromBitbucket {
    owner = "tkatchev";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "049wx24b4v8alhvc05z7snyzaf6fk9w2npc4kklp366yjl1l4qbb";
  };

  buildInputs = [ python2 ];

  doCheck = true;

  checkPhase = ''make test'';

  installPhase = ''
    mkdir -p $out/bin
    cp tab $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Programming language/shell calculator";
    homepage    = https://tkatchev.bitbucket.io/tab/;
    license     = licenses.boost;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = with platforms; linux;
  };
}
