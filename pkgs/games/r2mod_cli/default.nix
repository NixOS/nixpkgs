{ fetchFromGitHub
, bashInteractive
, jq
, makeWrapper
, p7zip
, lib, stdenv
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "sha256-FS9P/uTZU4d6zpM3TlEW6i6PLGHxqqO2fc8D7VsPCig=";
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
