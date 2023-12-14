{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config
, texinfo, makeWrapper, guile, guile-config }:

stdenv.mkDerivation rec {
  pname = "guile-hall";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "a-sassmannshausen";
    repo = "guile-hall";
    rev = version;
    hash = "sha256-TUCN8kW44X6iGbSJURurcz/Tc2eCH1xgmXH1sMOMOXs=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config texinfo makeWrapper ];

  buildInputs = [ guile guile-config ];

  enableParallelBuilding = true;

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/hall \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    export HOME=$TMPDIR
    $out/bin/hall --version | grep ${version} > /dev/null
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Project manager and build tool for GNU guile";
    homepage = "https://gitlab.com/a-sassmannshausen/guile-hall";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = guile.meta.platforms;
  };
}
