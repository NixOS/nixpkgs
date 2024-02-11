{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, alsa-lib
, libpcap
, expect
}:

rustPlatform.buildRustPackage rec {
  pname = "nethoscope";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vvilhonen";
    repo = "nethoscope";
    rev = "v${version}";
    hash = "sha256-v7GO+d4b0N3heN10+WSUJEpcShKmx4BPR1FyZoELWzc=";
  };

  cargoHash = "sha256-0yLMscmjHeU8dRDzx3kgniCRsekg9ZJWdN13hyqJgDI=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    alsa-lib
    libpcap
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    libpcap
    alsa-lib
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$(${expect}/bin/unbuffer "$out/bin/${pname}" --help 2> /dev/null | strings | grep ${version} | tr -d '\n')" == " ${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
  '';

  meta = with lib; {
    description = "Listen to your network traffic";
    longDescription = ''
      Employ your built-in wetware pattern recognition and
      signal processing facilities to understand your network traffic.
    '';
    homepage = "https://github.com/vvilhonen/nethoscope";
    license = licenses.isc;
    maintainers = with maintainers; [ _0x4A6F ];
    platforms = platforms.linux;
  };

}
