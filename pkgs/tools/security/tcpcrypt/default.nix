{ stdenv, fetchFromGitHub, autoreconfHook
, openssl
, libcap, libpcap, libnfnetlink, libnetfilter_conntrack, libnetfilter_queue
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "tcpcrypt-${version}";
  version = "0.4";

  src = fetchFromGitHub {
    repo = "tcpcrypt";
    owner = "scslab";
    rev = "v${version}";
    sha256 = "04n1qpf4x8x289xa7jndmx99xp0lbxjzjw013kf64i1n70i9wbnp";
  };

  postUnpack = ''mkdir -vp $sourceRoot/m4'';

  outputs = [ "bin" "dev" "out" ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl ]
    ++ optionals stdenv.isLinux [ libcap libpcap libnfnetlink libnetfilter_conntrack libnetfilter_queue ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://tcpcrypt.org/;
    description = "Fast TCP encryption";
    platforms = platforms.all;
    license = licenses.bsd2;
  };
}
