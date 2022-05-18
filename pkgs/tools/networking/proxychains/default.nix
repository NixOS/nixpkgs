{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "proxychains";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "haad";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "083xdg6fsn8c2ns93lvy794rixxq8va6jdf99w1z0xi4j7f1nyjw";
  };

  postPatch = ''
    # Suppress compiler warning. Remove it when upstream fix arrives
    substituteInPlace Makefile --replace "-Werror" "-Werror -Wno-stringop-truncation"
  '';

  installFlags = [
    "install-config"
  ];

  meta = with lib; {
    description = "Proxifier for SOCKS proxies";
    homepage = "http://proxychains.sourceforge.net";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
