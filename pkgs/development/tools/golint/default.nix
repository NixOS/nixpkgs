{ lib, goPackages, fetchFromGitHub }:

with goPackages;

buildGoPackage rec {
  rev = "8ca23475bcb43213a55dd8210b69363f6b0e09c1";
  name = "golint-${lib.strings.substring 0 7 rev}";
  goPackagePath = "github.com/golang/lint";

  src = fetchFromGitHub {
    inherit rev;
    owner = "golang";
    repo = "lint";
    sha256 = "16wbykik6dw3x9s7iqi4ln8kvzsh3g621wb8mk4nfldw7lyqp3cs";
  };

  subPackages = [ "golint" ];

  dontInstallSrc = true;

  meta = with lib; {
    description = "Linter for Go source code";
    homepage = https://github.com/golang/lint;
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
