{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "201710";
  name = "pcm-${version}";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = "${version}";
    sha256 = "02rq8739zwwbfrhagvcgf6qpmnswxl9b0qsld26rg6zp91v2npbj";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp pcm*.x $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Processor counter monitor";
    homepage = https://www.intel.com/software/pcm;
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
