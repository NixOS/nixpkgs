{ stdenv, fetchurl, autoreconfHook, intltool, pkgconfig, gtk3, SDL2, xorg
, wrapGAppsHook, libcdio, nasm, ffmpeg, file
, fetchpatch }:

stdenv.mkDerivation rec {
  name = "pcsxr-${version}";
  version = "1.9.94";

  # codeplex does not support direct downloading
  src = fetchurl {
    url = "mirror://debian/pool/main/p/pcsxr/pcsxr_${version}.orig.tar.xz";
    sha256 = "0q7nj0z687lmss7sgr93ij6my4dmhkm2nhjvlwx48dn2lxl6ndla";
  };

  patches = [
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/01_fix-i386-exec-stack.patch?h=debian/1.9.94-2";
      sha256 = "17497wjxd6b92bj458s2769d9bpp68ydbvmfs9gp51yhnq4zl81x";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/02_disable-ppc-auto-dynarec.patch?h=debian/1.9.94-2";
      sha256 = "0v8n79z034w6cqdrzhgd9fkdpri42mzvkdjm19x4asz94gg2i2kf";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/03_fix-plugin-dir.patch?h=debian/1.9.94-2";
      sha256 = "0vkl0mv6whqaz79kvvvlmlmjpynyq4lh352j3bbxcr0vjqffxvsy";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/04_update-homedir-symlinks.patch?h=debian/1.9.94-2";
      sha256 = "18r6n025ybr8fljfsaqm4ap31wp8838j73lrsffi49fkis60dp4j";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/05_format-security.patch?h=debian/1.9.94-2";
      sha256 = "03m4kfc9bk5669hf7ji1anild08diliapx634f9cigyxh72jcvni";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/06_warnings.patch?h=debian/1.9.94-2";
      sha256 = "0iz3g9ihnhisfgrzma9l74y4lhh57na9h41bmiam1millb796g71";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/07_non-linux-ip-addr.patch?h=debian/1.9.94-2";
      sha256 = "14vb9l0l4nzxcymhjjs4q57nmsncmby9qpdr7c19rly5wavm4k77";
    })
    ( fetchpatch {
      url = "https://anonscm.debian.org/cgit/pkg-games/pcsxr.git/plain/debian/patches/08_reproducible.patch?h=debian/1.9.94-2";
      sha256 = "1cx9q59drsk9h6l31097lg4aanaj93ysdz5p88pg9c7wvxk1qz06";
    })

    ./uncompress2.patch
  ];

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig wrapGAppsHook ];
  buildInputs = [
    gtk3 SDL2 xorg.libXv xorg.libXtst libcdio nasm ffmpeg file
  ];

  dynarecTarget =
   if stdenv.isx86_64 then "x86_64"
   else if stdenv.isi686 then "x86"
   else "no"; #debian patch 2 says ppc doesn't work

  configureFlags = [
    "--enable-opengl"
    "--enable-ccdda"
    "--enable-libcdio"
    "--enable-dynarec=${dynarecTarget}"
  ];

  postInstall = ''
    mkdir -p "$out/share/doc/${name}"
    cp README \
       AUTHORS \
       doc/keys.txt \
       doc/tweaks.txt \
       ChangeLog.df \
       ChangeLog \
       "$out/share/doc/${name}"
  '';

  meta = with stdenv.lib; {
    description = "Playstation 1 emulator";
    homepage = http://pcsxr.codeplex.com/;
    maintainers = with maintainers; [ rardiol ];
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
