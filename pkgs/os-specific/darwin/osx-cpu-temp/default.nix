{ lib, stdenv, fetchFromGitHub
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "osx-cpu-temp";
  version = "unstable-2020-12-04";

  src = fetchFromGitHub rec {
    name = "osx-cpu-temp-source";
    owner = "lavoiesl";
    repo = pname;
    rev = "6ec951be449badcb7fb84676bbc2c521e600e844";
    sha256 = "1nlibgr55bpln6jbdf8vqcp0fj9zv9343vflb7s9w0yh33fsbg9d";
  };

  buildInputs = [ IOKit ];

  installPhase = ''
    mkdir -p $out/bin
    cp osx-cpu-temp $out/bin
  '';

  meta = with lib; {
    description = "Outputs current CPU temperature for OSX.";
    homepage = "https://github.com/lavoiesl/osx-cpu-temp";
    license = licenses.gpl2;
    maintainers = with maintainers; [ virusdave ];
    platforms = platforms.darwin;
  };
}
