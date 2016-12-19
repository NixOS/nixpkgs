{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.13";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "1k75p9h29xx57l1c69ravm4pg9pmriqxmwja12hgrnvi251ayjw7";
  };

  patches = [ ./arm.patch ];

  hardeningDisable = [ "format" "pic" "relro" ];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
