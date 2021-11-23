{ lib, stdenv, fetchFromGitHub, pkg-config, curl, expat, fuse, gumbo, libuuid }:

stdenv.mkDerivation rec {
  pname = "httpdirfs";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "fangfufu";
    repo = pname;
    rev = version;
    sha256 = "sha256-IR+keGTEr1bPW6NIa7msH8DhwXrO6k1oGKdhe9Zl/pI=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl expat fuse gumbo libuuid ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = with lib; {
    description = "A FUSE filesystem for HTTP directory listings";
    homepage = "https://github.com/fangfufu/httpdirfs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sbruder ];
    platforms = platforms.unix;
  };
}
