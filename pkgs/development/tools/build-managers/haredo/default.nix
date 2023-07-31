{ lib, stdenvNoCC, fetchFromSourcehut, hare, scdoc }:

stdenvNoCC.mkDerivation rec {
  pname = "haredo";
  version = "1.0.2";

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = pname;
    rev = version;
    sha256 = "sha256-cCAzDRjJSMxrEIRCFD5z+Dss/KzBXnuGqwbi6Ox9Aq4=";
  };

  nativeBuildInputs = [ hare scdoc ];

  dontConfigure = true;
  preBuild = ''
    export HARECACHE=$(mktemp -d)
  '';
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://sr.ht/~autumnull/haredo";
    description = "A simple and unix-idiomatic build automator";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ stonks3141 ];
    inherit (hare.meta) platforms badPlatforms;
  };
}
