{ lib
, stdenv
, fetchFromGitHub
}:

let
  pname = "revolver";
  version = "0.2.3";
in
stdenv.mkDerivation {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "molovo";
      repo = "revolver";
      rev = "v${version}";
      hash = "sha256-ACYoMERjn/uv906mffNF1qu2j08nktqQFgwrfXdZX4g=";
    };

    preInstall = "mkdir -p $out/bin";

    installFlags = [ "PREFIX=$(out)" ];

    installPhase = ''
      runHook preInstall

      cp revolver $out/bin/revolver

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://github.com/molovo/revolver";
      description = "A progress spinner for ZSH scripts";
      license = licenses.mit;
      maintainers = with maintainers; [ jfvillablanca ];
    };
  }
