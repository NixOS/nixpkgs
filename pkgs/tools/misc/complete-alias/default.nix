{ lib
, fetchFromGitHub
, stdenvNoCC
}:

stdenvNoCC.mkDerivation rec {
  pname = "complete-alias";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "cykerway";
    repo = pname;
    rev = version;
    sha256 = "1s0prdnmb2qnzc8d7ddldzqa53yc10qq0lbgx2l9dzmz8pdwylyc";
  };

  buildPhase = ''
    runHook preBuild

    # required for the patchShebangs setup hook
    chmod +x complete_alias

    patchShebangs complete_alias

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r complete_alias "$out"/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automagical shell alias completion";
    homepage = "https://github.com/cykerway/complete-alias";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ tuxinaut ];
  };
}
