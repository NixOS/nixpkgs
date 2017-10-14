{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";
  version = "2.0.15";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "1rwl04y1mpb28yq5ynnk8j124dmhj5p8c4hcdn453sri2j37p6w9";
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
