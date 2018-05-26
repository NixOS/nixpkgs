{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook }:

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

  patches = [
    (fetchpatch {
      url = https://raw.githubusercontent.com/gentoo/gentoo/b64d15e731e3d6a7671f0ec6c34a20203cf2609d/sys-process/numactl/files/numactl-2.0.11-sysmacros.patch;
      sha256 = "05277kv3x12n2xlh3fgnmxclxfc384mkwb0v9pd91046khj6h843";
    })
  ] ++ stdenv.lib.optional stdenv.hostPlatform.isMusl (fetchpatch {
      url = https://git.alpinelinux.org/cgit/aports/plain/testing/numactl/musl.patch?id=0592b128c71c3e70d493bc7a13caed0d7fae91dd;
      sha256 = "080b0sygmg7104qbbh1amh3b322yyiajwi2d3d0vayffgva0720v";
    });

  meta = with stdenv.lib; {
    description = "Library and tools for non-uniform memory access (NUMA) machines";
    homepage = http://oss.sgi.com/projects/libnuma/;
    license = licenses.gpl2;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ wkennington ];
  };
}
