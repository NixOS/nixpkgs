{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, bashInteractive
}:

stdenv.mkDerivation rec {
  version = "unset";
  pname = "yallback";
  src = fetchFromGitHub {
    owner = "abathur";
    repo = "yallback";
    rev = "dfbc12e6155b21de74d09bf9d6e384ee16b71c03";
    hash = "sha256-QkkL23zSSM3bXJY/ReRkDycMeuU5OkufL7dmaGeeFqY=";
  };

  buildInputs = [ coreutils bashInteractive ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dv yallback $out/bin/yallback
    wrapProgram $out/bin/yallback --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  meta = with lib; {
    description = "Callbacks for YARA rule matches";
    homepage = https://github.com/abathur/yallback;
    license = licenses.mit;
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
