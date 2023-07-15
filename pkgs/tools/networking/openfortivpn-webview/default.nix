{ stdenv
, lib
, fetchFromGitHub
, qmake
, qtbase
, qtwebengine
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "openfortivpn-webview";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "gm-vm";
    repo = pname;
    rev = "607dc949730f24611a6dba6c5c6cb9a5669fd7ac";
    hash = "sha256-BNotbb2pL7McBm0SQwcgEvjgS2GId4HVaxWUz/ODs6w=";
  };

  sourceRoot = "source/openfortivpn-webview-qt";

  nativeBuildInputs = [ qmake wrapQtAppsHook ];
  buildInputs = [ qtwebengine ];

  installPhase = "install -Dm755 ${pname} -t $out/bin";

  meta = with lib; {
    description = "Application to perform the SAML single sing-on and easily retrieve the SVPNCOOKIE needed by openfortivpn.";
    homepage = "https://github.com/gm-vm/openfortivpn-webview";
    license = licenses.mit;
    maintainers = with maintainers; [ luz ];
    platforms = platforms.linux;
  };
}
