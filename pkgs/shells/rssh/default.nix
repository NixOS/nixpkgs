# CAVEATS:
# - Have only tested this with rsync, scp, and sftp. cvs support should work, but chroot integration is unlikely to function without further work
# - It is compiled without rdist support because rdist is ludicrously ancient (and not already in nixpkgs)

{ stdenv, fetchurl, openssh, rsync, cvs }:

stdenv.mkDerivation rec {
  name = "rssh-${version}";
  version = "2.3.4";

  src = fetchurl {
    url = "mirror://sourceforge/rssh/rssh/${version}/${name}.tar.gz";
    sha256 = "f30c6a760918a0ed39cf9e49a49a76cb309d7ef1c25a66e77a41e2b1d0b40cd9";
  };

  patches = [
    ./fix-config-path.patch

    # Patches from AUR
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0001-fail-logging.patch?h=rssh;
      name = "0001-fail-logging.patch";
      sha256 = "d30f2f4fdb1b57f94773f5b0968a4da3356b14a040efe69ec1e976c615035c65";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0002-info-to-debug.patch?h=rssh;
      name = "0002-info-to-debug.patch";
      sha256 = "86f6ecf34f62415b0d6204d4cbebc47322dc2ec71732d06aa27758e35d688fcd";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0003-man-page-spelling.patch?h=rssh;
      name = "0003-man-page-spelling.patch";
      sha256 = "455b3bbccddf1493999d00c2cd46e62930ef4fd8211e0b7d3a89d8010d6a5431";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0004-mkchroot.patch?h=rssh;
      name = "0004-mkchroot.patch";
      sha256 = "f7fd8723d2aa94e64e037c13c2f263a52104af680ab52bfcaea73dfa836457c2";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0005-mkchroot-arch.patch?h=rssh;
      name = "0005-mkchroot-arch.patch";
      sha256 = "ac8894c4087a063ae8267d2fdfcde69c2fe6b67a8ff5917e4518b8f73f08ba3f";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0006-mkchroot-symlink.patch?h=rssh;
      name = "0006-mkchroot-symlink.patch";
      sha256 = "bce98728cb9b55c92182d4901c5f9adf49376a07c5603514b0004e3d1c85e9c7";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0007-destdir.patch?h=rssh;
      name = "0007-destdir.patch";
      sha256 = "7fa03644f81dc37d77cc7e2cad994f17f91b2b8a49b1a74e41030a4ac764385e";
    })
    (fetchurl {
      url = https://aur.archlinux.org/cgit/aur.git/plain/0008-rsync-protocol.patch?h=rssh;
      name = "0008-rsync-protocol.patch";
      sha256 = "0c772afe9088eeded129ead86775ef18e58c318bbc58fc3e2585e7ff09cc5e91";
    })
  ];

  # Run this after to avoid conflict with patches above
  postPatch = ''
    sed -i '/chmod u+s/d' Makefile.in
  '';


  buildInputs = [ openssh rsync cvs ];

  configureFlags = [
    "--with-sftp-server=${openssh}/libexec/sftp-server"
    "--with-scp=${openssh}/bin/scp"
    "--with-rsync=${rsync}/bin/rsync"
    "--with-cvs=${cvs}/bin/cvs"
  ];


  meta = with stdenv.lib; {
    description = "A restricted shell for use with OpenSSH, allowing only scp and/or sftp";
    longDescription = ''
      rssh also includes support for rsync and cvs. For example, if you have a server which you only want to allow users to copy files off of via scp, without providing shell access, you can use rssh to do that.
    '';
    homepage = http://www.pizzashack.org/rssh/;
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ arobyn ];
  };

  passthru = {
    shellPath = "/bin/rssh";
  };
}
