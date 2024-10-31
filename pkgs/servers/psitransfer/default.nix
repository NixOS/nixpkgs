{ lib
, buildNpmPackage
, fetchFromGitHub
, pkg-config
, vips
}:

let
  pname = "psitransfer";
  version = "2.2.0";
  src = fetchFromGitHub {
    owner = "psi-4ward";
    repo = "psitransfer";
    rev = "v${version}";
    hash = "sha256-5o4QliAXgSZekIy0CNWfEuOxNl0uetL8C8RKUJ8HsNA=";
  };
  app = buildNpmPackage {
    pname = "${pname}-app";
    inherit version src;

    npmDepsHash = "sha256-q7E+osWIf6VZ3JvxCXoZYeF28aMgmKP6EzQkksUUjeY=";

    postPatch = ''
      # https://github.com/psi-4ward/psitransfer/pull/284
      touch public/app/.npmignore
      cd app
    '';

    installPhase = ''
      cp -r ../public/app $out
    '';
  };
in buildNpmPackage {
  inherit pname version src;

  npmDepsHash = "sha256-EW/Fej58LE/nbJomPtWvEjDveAUdo0jIWwC+ziN0gy0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    vips  # for 'sharp' dependency
  ];

  postPatch = ''
    rm -r public/app
    cp -r ${app} public/app
  '';

  dontBuild = true;

  meta = {
    homepage = "https://github.com/psi-4ward/psitransfer";
    description = "Simple open source self-hosted file sharing solution";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hyshka ];
    mainProgram = "psitransfer";
  };
}
