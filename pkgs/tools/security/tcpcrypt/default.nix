{ stdenv, fetchFromGitHub, autoreconfHook
, openssl, lib
, libcap, libpcap, libnfnetlink, libnetfilter_conntrack, libnetfilter_queue
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tcpcrypt-${version}";
  version = "0.5";

  src = fetchFromGitHub {
    repo = "tcpcrypt";
    owner = "scslab";
    rev = "v${version}";
    sha256 = "0a015rlyvagz714pgwr85f8gjq1fkc0il7d7l39qcgxrsp15b96w";
  };

  postUnpack = ''mkdir -vp $sourceRoot/m4'';

  outputs = [ "bin" "dev" "out" ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl libpcap ]
    ++ optionals stdenv.isLinux [ libcap libnfnetlink libnetfilter_conntrack libnetfilter_queue ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://tcpcrypt.org/;
    description = "Fast TCP encryption";
    platforms = platforms.all;
    license = licenses.bsd2;
  };
}
