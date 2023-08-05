{ lib
, stdenv
, fetchFromGitHub
, findup
, testers
, zigHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "booniepepper";
    repo = "findup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Tpyiy5oJQ04lqVEOFshFC0+90VoNILQ+N6Dd7lbuH/Q=";
  };

  nativeBuildInputs = [ zigHook ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.findup; };

  meta = {
    homepage = "https://github.com/booniepepper/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
  };
})
