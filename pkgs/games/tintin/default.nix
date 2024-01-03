{ stdenv, fetchFromGitHub, lib, zlib, pcre
, memorymappingHook, memstreamHook
, gnutls
}:

stdenv.mkDerivation rec {
  pname = "tintin";
  version = "2.02.40";

  src = fetchFromGitHub {
    owner = "scandum";
    repo = "tintin";
    rev = version;
    hash = "sha256-nJTxAAM5HOStYFjEopLA47ruM9uoVway+aH97AdXo/w=";
  };

  buildInputs = [ zlib pcre gnutls ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memorymappingHook memstreamHook ];

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    description = "A free MUD client for macOS, Linux and Windows";
    homepage    = "https://tintin.mudhalla.net/index.php";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ abathur ];
    mainProgram = "tt++";
    platforms   = platforms.unix;
  };
}
