{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  version = "9.0";
  pname = "tab";

  src = fetchFromGitHub {
    owner = "ivan-tkatchev";
    repo = pname;
    rev = version;
    sha256 = "sha256-2keVGPRYV2KCeJ+LgAcl74cjW5wvp6Rmy7VNMtdliBE=";
  };

  checkInputs = [ python3 ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    substituteInPlace Makefile --replace "python2 go2.py" "python go.py"
  '';

  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin tab
    install -Dm444 -t $out/share/doc/tab docs/*.html

    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming language/shell calculator";
    homepage    = "https://tkatchev.bitbucket.io/tab/";
    license     = licenses.boost;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = with platforms; unix;
  };
}
