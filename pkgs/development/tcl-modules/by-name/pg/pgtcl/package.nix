{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  autoreconfHook,
  libpq,
}:

mkTclDerivation rec {
  pname = "pgtcl";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "Pgtcl";
    tag = "v${version}";
    hash = "sha256-dT2c/lB5dqOJaZuTk9xLFomIsHcgU9nJ5Un22B9Tjms=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libpq
  ];

  env.PG_CONFIG = "${libpq.pg_config}/bin/pg_config";

  meta = {
    description = "Tcl client side interface to PostgreSQL";
    homepage = "https://flightaware.github.io/Pgtcl/";
    changelog = "https://github.com/flightaware/Pgtcl/blob/v${version}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
