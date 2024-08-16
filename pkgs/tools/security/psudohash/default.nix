{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "psudohash";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "t3l3machus";
    repo = "psudohash";
    rev = "refs/tags/v${version}";
    hash = "sha256-l/Rp9405Wf6vh85PFrRTtTLJE7GPODowseNqEw42J18=";
  };

  buildInputs = [ python3 ];

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
    changelog = "https://github.com/t3l3machus/psudohash/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ exploitoverload ];
    mainProgram = "psudohash";
  };
}
