{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  autoreconfHook,
  libpq,
}:

mkTclDerivation (finalAttrs: {
  pname = "pgtcl";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "Pgtcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+1qwU5ukbaeTHoOIIj1xU9XR7AvtkHnssIcNLLFDLjY=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libpq
  ];

  env.PG_CONFIG = "${libpq.pg_config}/bin/pg_config";

  tclRequiresCheck = [ "Pgtcl" ];

  meta = {
    description = "Tcl client side interface to PostgreSQL";
    homepage = "https://flightaware.github.io/Pgtcl/";
    changelog = "https://github.com/flightaware/Pgtcl/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
