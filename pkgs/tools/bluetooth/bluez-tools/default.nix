{ lib, stdenv, autoreconfHook, readline
, fetchFromGitHub, glib, pkg-config }:

stdenv.mkDerivation rec {
  version = "unstable-2020-10-24";
  pname = "bluez-tools";

  src = fetchFromGitHub {
    owner = "khvzak";
    repo = "bluez-tools";
    rev = "f65321736475429316f07ee94ec0deac8e46ec4a";
    sha256 = "0xk39lz3hm8lcnb5fdbfz4ldbbq8gswg95vilzdwxzrglcr6xnqq";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ readline glib ];

  meta = with lib; {
    description = "Command line bluetooth manager for Bluez5";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.unix;
  };

}
