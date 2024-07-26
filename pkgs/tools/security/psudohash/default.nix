{ lib
, stdenv
, fetchFromGitHub
, python3
}:

stdenv.mkDerivation rec {
  pname = "psudohash";
  version = "unstable-2023-05-15";

  src = fetchFromGitHub {
    owner = "t3l3machus";
    repo = "psudohash";
    # https://github.com/t3l3machus/psudohash/issues/8
    rev = "2d586dec8b5836546ae54b924eb59952a7ee393c";
    hash = "sha256-l/Rp9405Wf6vh85PFrRTtTLJE7GPODowseNqEw42J18=";
  };

  buildInputs = [
    python3
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 psudohash.py $out/bin/psudohash

    install -Dm444 common_padding_values.txt $out/share/psudohash/common_padding_values.txt

    substituteInPlace $out/bin/psudohash \
      --replace "common_padding_values.txt" "$out/share/${pname}/common_padding_values.txt"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Password list generator for orchestrating brute force attacks and cracking hashes";
    homepage = "https://github.com/t3l3machus/psudohash";
    license = licenses.mit;
    maintainers = with maintainers; [ exploitoverload ];
    mainProgram = "psudohash";
  };
}
