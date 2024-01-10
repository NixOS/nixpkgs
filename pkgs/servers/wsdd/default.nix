{ lib, stdenv, fetchFromGitHub, installShellFiles, makeWrapper, nixosTests, python3 }:

stdenv.mkDerivation rec {
  pname = "wsdd";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "christgau";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xfZVGi3OxuRI+Zh6L3Ru4J4j5BB1EAN3fllRCVA/c5o=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildInputs = [ python3 ];

  patches = [
    # Increase timeout to socket urlopen
    # See https://github.com/christgau/wsdd/issues/80#issuecomment-76848906
    ./increase_timeout.patch
  ];

  installPhase = ''
    install -Dm0555 src/wsdd.py $out/bin/wsdd
    installManPage man/wsdd.8
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
    mainProgram = "wsdd";
  };
}
