{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "d0-blind-id";
  version = "0.8.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "xonotic";
    repo = "d0_blind_id";
    rev = "xonotic-v${finalAttrs.version}";
    hash = "sha256-ERiZZ32GMoLt0Fkp0yAhhW91tvXyjFlK3BlLaOl+HtM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gmp ];

  configureFlags = [
    "--enable-static"
    "--enable-shared"
  ];

  meta = {
    description = "Cryptographic library for identification using Schnorr Identification scheme and Blind RSA";
    homepage = "https://gitlab.com/xonotic/d0_blind_id";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ zalakain ];
  };
})
