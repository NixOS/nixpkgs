{ stdenv, fetchurl, zlib }:

let version = "2.0.11"; in
stdenv.mkDerivation rec {
  name = "kexec-tools-${version}";

  src = fetchurl {
    urls = [
      "mirror://kernel/linux/utils/kernel/kexec/${name}.tar.xz"
      "http://horms.net/projects/kexec/kexec-tools/${name}.tar.xz"
    ];
    sha256 = "1qrfka9xvy77k0rg3k0cf7xai0f9vpgsbs4l3bs8r4nvzy37j2di";
  };

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    inherit version;
    homepage = http://horms.net/projects/kexec/kexec-tools;
    description = "Tools related to the kexec Linux feature";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
