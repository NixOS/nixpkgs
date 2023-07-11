{ stdenv, lib, fetchFromGitLab, makeWrapper, bash }:

stdenv.mkDerivation rec {
  pname = "sensible-utils";
  version = "0.0.18";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "sensible-utils";
    rev = "debian/${version}";
    sha256 = "sha256-fZJKPnEkPfo/3luUcHzAmGB2k1nkA4ATEQMSz0aN0YY=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/bin

    cp sensible-browser sensible-editor sensible-pager sensible-terminal $out/bin/
  '';

  meta = with lib; {
    description = "The package provides utilities used by programs to sensibly select and spawn an appropriate browser, editor, or pager.";
    longDescription = ''
       The specific utilities included are:
       - sensible-browser
       - sensible-editor
       - sensible-pager
    '';
    homepage = "https://salsa.debian.org/debian/sensible-utils";
    changelog = "https://salsa.debian.org/debian/sensible-utils/-/tags";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pbek ];
    platforms = platforms.unix;
  };
}

