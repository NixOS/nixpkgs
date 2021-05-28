{ buildChromiumExtension, fetchFromGitHub, p7zip }:

buildChromiumExtension rec {
  pname = "bypass-paywalls";
  version = "1.7.5";

  src = fetchFromGitHub {
    owner = "iamadamdev";
    repo = "bypass-paywalls-chrome";
    rev = "v${version}";
    sha256 = "1invkzd5q21jranaaqmi975v8m4ar5x4wx11ylsvz3mrs3dv7ah8";
  };

  nativeBuildInputs = [ p7zip ];

  buildPhase = ''
    cd ./build
    source ./build.sh
  '';

  preInstall = ''
    tmpout=$(mktemp -d)
    7z x -o$tmpout output/bypass-paywalls.crx
    cd $tmpout
  '';
}
