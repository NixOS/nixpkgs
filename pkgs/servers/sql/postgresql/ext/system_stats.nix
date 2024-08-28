{
  fetchFromGitHub,
  lib,
  stdenv,
  postgresql,
}:
stdenv.mkDerivation rec {
  pname = "system_stats";
  version = "3.0";

  buildInputs = [ postgresql ];

  src = fetchFromGitHub {
    owner = "EnterpriseDB";
    repo = "system_stats";
    rev = "v${version}";
    hash = "sha256-LuX7/LOi0rl6L/kjbjq7rr2zPcGIOYB7hdZBNJ9xqak=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{lib,share/postgresql/extension}

    cp *${postgresql.dlSuffix} $out/lib
    cp *.sql     $out/share/postgresql/extension
    cp *.control $out/share/postgresql/extension

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Postgres extension for exposing system metrics such as CPU, memory and disk information";
    homepage = "https://github.com/EnterpriseDB/system_stats";
    changelog = "https://github.com/EnterpriseDB/system_stats/raw/v${version}/CHANGELOG.md";
    maintainers = with maintainers; [ shivaraj-bh ];
    platforms = postgresql.meta.platforms;
    license = licenses.postgresql;
  };
}
