{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, coreutils
, bashInteractive
}:

stdenv.mkDerivation rec {
  version = "0.2.0";
  pname = "yallback";
  src = fetchFromGitHub {
    owner = "abathur";
    repo = "yallback";
    rev = "v${version}";
    hash = "sha256-t+fdnDJMFiFqN23dSY3TnsZsIDcravtwdNKJ5MiZosE=";
  };

  buildInputs = [ coreutils bashInteractive ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dv yallback $out/bin/yallback
    wrapProgram $out/bin/yallback --prefix PATH : ${lib.makeBinPath [ coreutils ]}
  '';

  meta = with lib; {
    description = "Callbacks for YARA rule matches";
    mainProgram = "yallback";
    homepage = "https://github.com/abathur/yallback";
    license = licenses.mit;
    maintainers = with maintainers; [ abathur ];
    platforms = platforms.all;
  };
}
