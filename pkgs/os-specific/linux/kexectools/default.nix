{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.14";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "1ihd3kzw8xnc5skq4pb633rr80007knjm4n1dd67a24xkplygcpz";
  };

  hardeningDisable = [ "format" "pic" "relro" ];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
