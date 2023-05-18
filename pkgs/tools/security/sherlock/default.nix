{ stdenv, lib, fetchFromGitHub, python3, makeWrapper }:
let
  pyenv = python3.withPackages (pp: with pp; [
    beautifulsoup4
    certifi
    colorama
    lxml
    pandas
    pysocks
    requests
    requests-futures
    soupsieve
    stem
    torrequest
  ]);
in
stdenv.mkDerivation rec {
  pname = "sherlock";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = pname;
    rev = "ab2f6788340903df797d8c336a97fa6e742daf77";
    hash = "sha256-AbWZa33DNrDM0FdjoFSVMnz4Ph7mUiUe/erhI3w7GQQ";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace sherlock/sherlock.py \
      --replace "os.path.dirname(__file__)" "\"$out/share\""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    cp ./sherlock/*.py $out/bin/
    cp --recursive ./sherlock/resources/ $out/share
    makeWrapper ${pyenv.interpreter} $out/bin/sherlock --add-flags "$out/bin/sherlock.py"
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    cd $srcRoot/sherlock
    ${pyenv.interpreter} -m unittest tests.all.SherlockSiteCoverageTests --verbose
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://sherlock-project.github.io/";
    description = "Hunt down social media accounts by username across social networks";
    license = licenses.mit;
    maintainers = with maintainers; [ applePrincess ];
  };
}
