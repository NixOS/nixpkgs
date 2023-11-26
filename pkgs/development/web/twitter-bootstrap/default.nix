{ lib
, stdenv
, fetchurl
, unzip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bootstrap";
  version = "5.3.2";

  src = fetchurl {
    url = "https://github.com/twbs/bootstrap/releases/download/v${finalAttrs.version}/bootstrap-${finalAttrs.version}-dist.zip";
    hash = "sha256-hUlReGqLkaBeQ9DyIATFyddhdeFv1vUNeTnnsBhMPgk=";
  };

  nativeBuildInputs = [ unzip ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r * $out/

    runHook postInstall
  '';

  meta = {
    description = "Front-end framework for faster and easier web development";
    homepage = "https://getbootstrap.com/";
    license = lib.licenses.mit;
  };
})
