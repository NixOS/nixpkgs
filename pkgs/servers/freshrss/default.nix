{ stdenv, lib, fetchFromGitHub }:

let
  pname = "FreshRSS";
  version = "1.18.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "189rwfpp5chv11p12bkyr64wpxap03gkhim90vm961qnixbypbdw";
  };

  # There's nothing to build.
  dontBuild = true;

  installPhase = ''
    mkdir -p $out

    cp -vr * $out/
  '';

  meta = with lib; {
    description = "FreshRSS is a free, self-hostable RSS aggregator";
    homepage = "https://www.freshrss.org/";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.etu ];
  };
}
