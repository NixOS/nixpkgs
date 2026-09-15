{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  autoreconfHook,
  libpq,
}:

mkTclDerivation (finalAttrs: {
  pname = "pgtcl";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "flightaware";
    repo = "Pgtcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rvGtQRmbWnvMGfPf7azjAdeVppjthTmFLuROBKZaD+A=";
  };

  # Fix Tcl9 stubs build
  # https://github.com/flightaware/Pgtcl/pull/62
  postPatch = ''
    substituteInPlace generic/pgtcl.c \
      --replace-fail 'Tcl_InitStubs(interp, "8.1"' 'Tcl_InitStubs(interp, "8.1-"'
  '';

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
