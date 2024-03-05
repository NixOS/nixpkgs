{ stdenv
, mlton
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "initool";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "dbohdan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wb9hJ0R1R7kYt+TWznqfVGKms3hQjzB8TJYpS89da/E=";
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

