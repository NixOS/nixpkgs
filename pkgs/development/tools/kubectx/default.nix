{ stdenv, lib, fetchFromGitHub, kubectl, makeWrapper }:

with lib;

stdenv.mkDerivation rec {
  name = "kubectx";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = "${name}";
    rev = "v${version}";
    sha256 = "1bmmaj5fffx4hy55l6x4vl5gr9rp2yhg4vs5b9sya9rjvdkamdx5";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    cp kubectx $out/bin
    cp kubens $out/bin

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${makeBinPath [ kubectl ]}
    done
  '';

  meta = {
    description = "Fast way to switch between clusters and namespaces in kubectl!";
    license = licenses.asl20;
    homepage = https://github.com/ahmetb/kubectx;
    maintainers = with maintainers; [ periklis ];
    platforms = with platforms; unix;
  };
}
