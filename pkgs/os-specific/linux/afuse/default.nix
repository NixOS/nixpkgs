args: with args;
stdenv.mkDerivation {
  name = "afuse-0.2";

  src = fetchurl {
    url = mirror://sourceforge/afuse/0.2/afuse-0.2.tar.gz;
    sha256 = "1lj2jdks0bgwxbjqp5a9f7qdry19kar6pg7dh1ml98gapx9siylj";
  };

  buildInputs = [pkgconfig fuse];

  meta = { 
    description = "automounting in userspace. Allows easy access to ssh-agent etc";
    longDesc = ''
      Example: (automunt using sshfs by accessing ~/sshfs/[user@]domain
      afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/sshfs/
    '';
    homepage = http://sourceforge.net/projects/afuse;
    license = "GPL-v2";
    maintainers = [args.lib.maintainers.marcweber];
    platforms = args.lib.platforms.linux;
  };
}

