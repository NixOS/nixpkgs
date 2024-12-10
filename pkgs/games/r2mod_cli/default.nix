{
  fetchFromGitHub,
  bashInteractive,
  jq,
  makeWrapper,
  p7zip,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "sha256-VtJtAyojFOkMLBfpQ6N+8fDDkcJtVCflWjwsdq8OD0w=";
  };

  buildInputs = [ bashInteractive ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram $out/bin/r2mod --prefix PATH : "${
      lib.makeBinPath [
        jq
        p7zip
      ]
    }";
  '';

  meta = with lib; {
    description = "A Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://github.com/foldex/r2mod_cli";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.reedrw ];
    mainProgram = "r2mod";
    platforms = platforms.unix;
  };
}
