{ stdenv
, mlton
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "initool";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LV8Rv+7oUJ/4BX412WD1+Cs7N86OiXutN2ViAmo5jlE=";
  };

  nativeBuildInputs = [ mlton ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp initool $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    inherit (mlton.meta) platforms;

    description = "Manipulate INI files from the command line";
    homepage = "https://github.com/dbohdan/initool";
    license = licenses.mit;
    maintainers = with maintainers; [ e1mo ];
    changelog = "https://github.com/dbohdan/initool/releases/tag/v${version}";
  };
}

