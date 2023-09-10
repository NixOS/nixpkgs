{ lib
, stdenvNoCC
, fetchFromGitHub
, coreutils
, gnused
, postgresql
, makeWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "psql2csv";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "fphilipe";
    repo = "psql2csv";
    rev = "v${version}";
    hash = "sha256-XIdZ2+Jlw2JLn4KXD9h3+xXymu4FhibAfp5uGGkVwLQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin psql2csv
    wrapProgram $out/bin/psql2csv \
      --prefix PATH : ${lib.makeBinPath [ coreutils gnused postgresql ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to run a PostreSQL query and output the result as CSV";
    homepage = "https://github.com/fphilipe/psql2csv";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    inherit (postgresql.meta) platforms;
  };
}
