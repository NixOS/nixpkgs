{ lib, stdenv, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  version = "9.1";
  pname = "tab";

  src = fetchFromGitHub {
    owner = "ivan-tkatchev";
    repo = pname;
    rev = version;
    sha256 = "sha256-AhgWeV/ojB8jM16A5ggrOD1YjWfRVcoQbkd3S2bgdyE=";
  };

  checkInputs = [ python3 ];

  doCheck = !stdenv.isDarwin;

  checkTarget = "test";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin tab
    install -Dm444 -t $out/share/doc/tab docs/*.html

    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming language/shell calculator";
    homepage    = "http://tab-lang.xyz";
    license     = licenses.boost;
    maintainers = with maintainers; [ mstarzyk ];
    platforms   = with platforms; unix;
  };
}
