{ lib, stdenv, fetchFromGitHub, autoreconfHook, cmake, libtool, pkg-config
, zlib, openssl, libevent, ncurses, ruby, msgpack, libssh }:

stdenv.mkDerivation rec {
  pname = "tmate-ssh-server";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner  = "tmate-io";
    repo   = "tmate-ssh-server";
    rev    = version;
    sha256 = "1y77mv1k4c79glj84lzlp0s1lafr1jzf60mywr5vhy6sq47q8hwd";
  };

  dontUseCmakeConfigure = true;

  buildInputs = [ libtool zlib openssl libevent ncurses ruby msgpack libssh ];
  nativeBuildInputs = [ autoreconfHook cmake pkg-config ];

  meta = with lib; {
    homepage    = "https://tmate.io/";
    description = "tmate SSH Server";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ ];
    knownVulnerabilities = [ "CVE-2021-44513" "CVE-2021-44512" ];
  };
}

