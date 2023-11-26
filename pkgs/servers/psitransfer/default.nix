{ lib
, buildNpmPackage
, fetchFromGitHub
}:

let
  pname = "psitransfer";
  version = "2.1.2";
  src = fetchFromGitHub {
    owner = "psi-4ward";
    repo = "psitransfer";
    rev = "v${version}";
    hash = "sha256-dBAieXIwCEstR9m+6+2/OLPKo2qHynZ1t372Il0mkXk=";
  };
  app = buildNpmPackage {
    pname = "${pname}-app";
    inherit version src;

    npmDepsHash = "sha256-iCd+I/aTMwQqAMRHan3T191XNz4S3Cy6CDxSLIYY7IA=";

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

  npmDepsHash = "sha256-H22T5IU8bjbsWhwhchDqppvYfcatbXSWqp6gdoek1Z8=";

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
