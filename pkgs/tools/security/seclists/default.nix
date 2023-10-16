{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "seclists";
  version = "2023.3";

  src = fetchFromGitHub {
    owner = "danielmiessler";
    repo = "SecLists";
    rev = "2023.3";
    sha256 = "sha256-mJgCzp8iKzSWf4Tud5xDpnuY4aNJmnEo/hTcuGTaOWM=";
  };

  # Use a more user-friendly output directory
  outputs = [ "out" ];

  # Use postInstall to copy the files to the wordlists directory
  postInstall = ''
    mkdir -p $out/share/seclists
    cp -R * $out/share/seclists
  '';

  meta = with lib; {
    description = "Collection of useful security lists";
    homepage = "https://github.com/danielmiessler/SecLists";
    license = licenses.mit;
    maintainers = with maintainers; [ tochiaha ];
    platforms = platforms.all;
  };
}

