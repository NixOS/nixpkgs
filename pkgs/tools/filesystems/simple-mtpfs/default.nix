{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, autoconf-archive
, pkg-config
, fuse
, libmtp
}:
stdenv.mkDerivation rec {
  pname = "simple-mtpfs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "phatina";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vAqi2owa4LJK7y7S7TwkPAqDxzyHrZZBTu0MBwMT0gI=";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config ];
  buildInputs = [ fuse libmtp ];

  meta = with lib; {
    description = "Simple MTP fuse filesystem driver";
    homepage = "https://github.com/phatina/simple-mtpfs";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ laalsaas ];
    mainProgram = "simple-mtpfs";
  };
}
