<<<<<<< HEAD
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
  };
}
=======
# To update package version:
#   1. Change version string in node-package.json and this file
#   2. Run `./generate.sh` to rebuild node dependencies with node2nix
#   3. Build this package `nix-build -A psitransfer`
#   4. Profit

{ stdenv
, pkgs
, lib
, nodejs_18
, fetchzip
}:

let
  nodejs = nodejs_18;

  nodePackages = import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };

  psitransfer = lib.head (lib.attrValues nodePackages);

  combined = psitransfer.override rec {
    # version is not defined in source package.json
    # version must also be maintained in node-packages.json for node2nix
    version = "2.1.2";

    # override node2nix package src to pull pre-built release of same version
    src = fetchzip {
      url = "https://github.com/psi-4ward/psitransfer/releases/download/v${version}/psitransfer-v${version}.tar.gz";
      sha256 = "mfldWTVmfcIRa+1g8YDnQqem5YmrFRfCxJoitWcXvns=";
      stripRoot = false;
    };

    meta = with lib; {
      homepage = "https://github.com/psi-4ward/psitransfer";
      description = "Simple open source self-hosted file sharing solution";
      license = licenses.bsd2;
      maintainers = with maintainers; [ hyshka ];
    };
  };
in
  combined
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
