{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, file, libuv
, raft-canonical, sqlite }:

stdenv.mkDerivation rec {
  pname = "dqlite";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zalsvr0vy7632nhm96a29lrfy18iqsmbxpyz2lvq80mrjlbrzsn";
  };

  nativeBuildInputs = [ autoreconfHook file pkg-config ];
  buildInputs = [
    libuv
    raft-canonical.dev
    sqlite
  ];

  enableParallelBuilding = true;

  # tests fail
  doCheck = false;

  outputs = [ "dev" "out" ];

  meta = with lib; {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = "https://dqlite.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ joko ];
    platforms = platforms.linux;
  };
}
