{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, libtorrent-jesec
, curl
, ncurses
, xmlrpc_c
, nlohmann_json
, xmlRpcSupport ? true
, jsonRpcSupport ? true
}:
let
  inherit (lib) optional;
in
stdenv.mkDerivation rec {
  pname = "rtorrent-jesec";
  version = "0.9.8-r14";

  src = fetchFromGitHub {
    owner = "jesec";
    repo = "rtorrent";
    rev = "v${version}";
    sha256 = "sha256-AbjzNIha3MkCZi6MuyUfPx9r3zeXeTUzkbD7uHB85lo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libtorrent-jesec curl ncurses ]
    ++ optional xmlRpcSupport xmlrpc_c
    ++ optional jsonRpcSupport nlohmann_json;

  cmakeFlags = [ "-DUSE_RUNTIME_CA_DETECTION=NO" ]
    ++ optional (!xmlRpcSupport) "-DUSE_XMLRPC=NO"
    ++ optional (!jsonRpcSupport) "-DUSE_JSONRPC=NO";

  doCheck = true;
  checkInputs = [ gtest ];

  prePatch = ''
    substituteInPlace src/main.cc \
      --replace "/etc/rtorrent/rtorrent.rc" "${placeholder "out"}/etc/rtorrent/rtorrent.rc"
  '';

  postFixup = ''
    mkdir -p $out/etc/rtorrent
    cp $src/doc/rtorrent.rc $out/etc/rtorrent/rtorrent.rc
  '';

  meta = with lib; {
    description = "An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach (jesec's fork)";
    homepage = "https://github.com/jesec/rtorrent";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ winterqt ];
    platforms = platforms.linux;
  };
}
