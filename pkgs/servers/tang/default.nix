{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, asciidoc
, jansson, jose, http-parser, systemd
}:

stdenv.mkDerivation rec {
  pname = "tang";
  version = "7";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y5w1jrq5djh9gpy2r98ja7676nfxss17s1dk7jvgblsijx9qsd7";
  };

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig asciidoc ];
  buildInputs = [ jansson jose http-parser systemd ];

  outputs = [ "out" "man" ];

  meta = {
    description = "Server for binding data to network presence.";
    homepage = "https://github.com/latchset/tang";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
  };
}
