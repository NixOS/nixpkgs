{ stdenv, lib, fetchFromGitHub, python3, makeWrapper }:
let
  pyenv = python3.withPackages (pp: with pp; [
    beautifulsoup4
    certifi
    colorama
    lxml
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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = pname;
    rev = "f8566960d461783558b7bcba5c818d9275de492a";
    sha256 = "sha256-6jG/SmsiEL63EcBrx2fcQDYbmMCA+A7Jsc3E4f5NGts=";
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
