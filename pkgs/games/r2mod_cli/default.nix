{ fetchFromGitHub
, bashInteractive
, jq
, makeWrapper
, p7zip
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "sha256-mVZCCQMKg9IErBkU7/sRuB3CEK61epbVcQ2MOYLlE1o=";
  };

  buildInputs = [ bashInteractive ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/r2mod --prefix PATH : "${lib.makeBinPath [ jq p7zip ]}";
  '';

  meta = with lib; {
    description = "A Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://github.com/foldex/r2mod_cli";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.reedrw ];
    platforms = platforms.unix;
  };
}
