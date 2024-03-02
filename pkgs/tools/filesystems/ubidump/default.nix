{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {

  pname = "ubidump";
  version = "unstable-2019-09-11";
  format = "other";

  src = fetchFromGitHub {
    owner = "nlitsme";
    repo = pname;
    rev = "0691f1a9a38604c2baf8c9af6b826eb2632af74a";
    sha256 = "1hiivlgni4r3nd5n2rzl5qzw6y2wpjpmyls5lybrc8imd6rmj3w2";
  };

  propagatedBuildInputs = with python3.pkgs; [ crcmod python-lzo setuptools ];

  dontBuild = true;

  patchPhase = ''
    sed -i '1s;^;#!${python3.interpreter}\n;' ubidump.py
    patchShebangs ubidump.py
  '';

  installPhase = ''
    install -D -m755 ubidump.py $out/bin/ubidump
    wrapProgram $out/bin/ubidump --set PYTHONPATH $PYTHONPATH
  '';

  installCheckPhase = ''
    $out/bin/ubidump -h  > /dev/null
  '';

  meta = with lib; {
    description = "View or extract the contents of UBIFS images";
    homepage = "https://github.com/nlitsme/ubidump";
    license = licenses.mit;
    maintainers = with maintainers; [ sgo ];
    mainProgram = "ubidump";
  };
}

