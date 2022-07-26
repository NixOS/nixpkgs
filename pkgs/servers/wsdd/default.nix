{ lib, stdenv, fetchFromGitHub, makeWrapper, nixosTests, python3 }:

stdenv.mkDerivation rec {
  pname = "wsdd";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "christgau";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9cwzkF2mg6yOIsurLMXTLoEIOsKbPIWMicpWBQ0XVhE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  patches = [
    # Increase timeout to socket urlopen
    # See https://github.com/christgau/wsdd/issues/80#issuecomment-76848906
    ./increase_timeout.patch
  ];

  installPhase = ''
    install -Dm0755 src/wsdd.py $out/bin/wsdd
    wrapProgram $out/bin/wsdd --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    tests.samba-wsdd = nixosTests.samba-wsdd;
  };

  meta = with lib; {
    homepage = "https://github.com/christgau/wsdd";
    description = "A Web Service Discovery (WSD) host daemon for SMB/Samba";
    maintainers = with maintainers; [ izorkin ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
