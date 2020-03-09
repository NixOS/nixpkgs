{ buildAppImage, fetchurl, stdenv }:

buildAppImage rec {
  pname = "colobot";
  version = "0.1.12-alpha";
  src = fetchurl {
    url = "https://colobot.info/files/releases/0.1.12-alpha/Colobot-${version}-x86_64.AppImage";
    sha256 = "da1b5b3ac8a072d1999c2ac8c65a6c1e0aad3c1a97e5dfd72c9a8c7f30c60fa5";
  };
  meta = {
    description = "RTS game, where you can program your units (bots) in a language called CBOT";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ genesis ];
  };
}
