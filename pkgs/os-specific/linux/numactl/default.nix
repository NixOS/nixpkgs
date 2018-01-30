{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "numactl-${version}";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "numactl";
    repo = "numactl";
    rev = "v${version}";
    sha256 = "0bcffqawwbyrnza8np0whii25mfd0dria35zal9v3l55xcrya3j9";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = http://oss.sgi.com/projects/libnuma/;
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ wkennington ];
  };
}
