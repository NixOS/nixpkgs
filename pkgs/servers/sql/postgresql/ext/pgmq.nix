{
  lib,
  stdenv,
  fetchFromGitHub,
  postgresql,
}:

stdenv.mkDerivation rec {
  pname = "pgmq";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "tembo-io";
    repo = "pgmq";
    rev = "v${version}";
    hash = "sha256-z+8/BqIlHwlMnuIzMz6eylmYbSmhtsNt7TJf/CxbdVw=";
  };

  sourceRoot = "${src.name}/pgmq-extension";

  dontConfigure = true;

  buildInputs = [ postgresql ];

  installPhase = ''
    runHook preInstall

    install -D -t $out/share/postgresql/extension sql/*.sql
    install -D -t $out/share/postgresql/extension *.control

    runHook postInstall
  '';

  meta = {
    description = "Lightweight message queue like AWS SQS and RSMQ but on Postgres";
    homepage = "https://tembo.io/pgmq";
    changelog = "https://github.com/tembo-io/pgmq/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ takeda ];
    platforms = postgresql.meta.platforms;
    license = lib.licenses.postgresql;
  };
}
