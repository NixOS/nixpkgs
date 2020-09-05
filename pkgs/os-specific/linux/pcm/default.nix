{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "202008";
  pname = "pcm";

  src = fetchFromGitHub {
    owner = "opcm";
    repo = "pcm";
    rev = version;
    sha256 = "1paxwq0p39vp2ma0rg7dkalc3r28wzj77sm3alavvk2vxgvxi0ig";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp pcm*.x $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Processor counter monitor";
    homepage = "https://www.intel.com/software/pcm";
    license = licenses.bsd3;
    maintainers = with maintainers; [ roosemberth ];
    platforms = [ "x86_64-linux" ];
  };
}
