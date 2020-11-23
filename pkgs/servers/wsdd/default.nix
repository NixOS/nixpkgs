{ stdenv, fetchFromGitHub, makeWrapper, nixosTests, python3 }:

stdenv.mkDerivation rec {
  pname = "wsdd";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "christgau";
    repo = pname;
    rev = "v${version}";
    sha256 = "0444xh1r5wd0zfch1hg1f9s4cw68srrm87hqx16qvlgx6jmz5j0p";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ python3 ];

  installPhase = ''
    install -Dm0755 src/wsdd.py $out/bin/wsdd
    wrapProgram $out/bin/wsdd --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  passthru = {
    tests.samba-wsdd = nixosTests.samba-wsdd;
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/christgau/wsdd";
    description = "A Web Service Discovery (WSD) host daemon for SMB/Samba";
    maintainers = with maintainers; [ izorkin ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
