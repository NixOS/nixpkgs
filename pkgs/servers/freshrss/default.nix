{ stdenv, lib, fetchFromGitHub, nixosTests }:

let
  pname = "FreshRSS";
  version = "1.19.2";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-UUDMYgYPvIuL5Jw2fFhJGoJ4KLNUBpk2pPc2UNa+ZSE=";
  };

  passthru.tests = nixosTests.freshrss;

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
