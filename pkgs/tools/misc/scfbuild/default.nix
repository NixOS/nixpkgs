{ lib, buildPythonApplication, fetchFromGitHub, python, pyyaml, fonttools, fontforge }:

buildPythonApplication rec {
  name = "scfbuild-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "eosrei";
    repo = "scfbuild";
    rev = "c179c8d279b7cc0a9a3536a713ac880ac6010318";
    sha256 = "1bsi7k4kkj914pycp1g92050hjxscyvc9qflqb3cv5yz3c93cs46";
  };

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  propagatedBuildInputs = [ pyyaml fonttools fontforge ];

  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    cp -r scfbuild $out/${python.sitePackages}
    cp -r bin $out
  '';

  meta = with lib; {
    description = "SVGinOT color font builder";
    homepage = https://github.com/eosrei/scfbuild;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
