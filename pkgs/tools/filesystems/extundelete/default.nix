{ lib, stdenv, fetchurl, e2fsprogs }:

stdenv.mkDerivation {
  version = "0.2.4";
  pname = "extundelete";

  src = fetchurl {
    url = "mirror://sourceforge/extundelete/extundelete-0.2.4.tar.bz2";
    sha256 = "1x0r7ylxlp9lbj3d7sqf6j2a222dwy2nfpff05jd6mkh4ihxvyd1";
  };

  buildInputs = [ e2fsprogs ];

  # inode field i_dir_acl was repurposed as i_size_high in e2fsprogs 1.44,
  # breaking the build
  patchPhase = ''
    substituteInPlace src/insertionops.cc \
      --replace "Directory ACL:" "High 32 bits of size:" \
      --replace "inode.i_dir_acl" "inode.i_size_high"
  '';

  meta = with lib; {
    description = "Utility that can recover deleted files from an ext3 or ext4 partition";
    homepage = "https://extundelete.sourceforge.net/";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.domenkozar ];
    mainProgram = "extundelete";
  };
}
