{ stdenv, fetchgit, pythonPackages }:

stdenv.mkDerivation rec {
  name = "speedtest-cli-dev";
  
  src = fetchgit {
    url = "https://github.com/sivel/speedtest-cli.git";
    rev = "fe0940c5744ebe74ca31ad44e6b181d82a89edab";
    sha256 = "0iywcmgqi58bhldcf8qn1nr7mihypi5fp9s13d4vqc7797xvb28k";
  };

  buildInputs = [ pythonPackages.python ];

  installPhase = ''
      mkdir -p $out/bin
      cp speedtest-cli $out/bin/
    '';

  meta = with stdenv.lib; {
    homepage = https://github.com/sivel/speedtest-cli;
    description = "Command line interface for testing internet bandwidth using speedtest.net";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = [ maintainers.iElectric ];
  };
}
