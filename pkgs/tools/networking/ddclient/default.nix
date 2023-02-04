{ lib, fetchFromGitHub, perlPackages, autoreconfHook, iproute2, perl }:

perlPackages.buildPerlPackage rec {
  pname = "ddclient";
  version = "3.10.0";

  outputs = [ "out" ];

  src = fetchFromGitHub {
    owner = "ddclient";
    repo = "ddclient";
    rev = "v${version}";
    sha256 = "sha256-wWUkjXwVNZRJR1rXPn3IkDRi9is9vsRuNC/zq8RpB1E=";
  };

  postPatch = ''
    touch Makefile.PL
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = with perlPackages; [ IOSocketINET6 IOSocketSSL JSONPP ];

  installPhase = ''
    runHook preInstall

    # patch sheebang ddclient script which only exists after buildPhase
    preConfigure
    install -Dm755 ddclient $out/bin/ddclient
    install -Dm644 -t $out/share/doc/ddclient COP* README.* ChangeLog.md

    runHook postInstall
  '';

  # TODO: run upstream tests
  doCheck = false;

  meta = with lib; {
    description = "Client for updating dynamic DNS service entries";
    homepage = "https://ddclient.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
