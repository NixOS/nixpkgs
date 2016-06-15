{ stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, python
, fuse
# The following are required for manpages
#, asciidoc, libxml2
, boost
, pkgconfig
, judy
, pam
, zlib # optional
}:

stdenv.mkDerivation rec {
  name = "lizardfs-${version}";
  version = "3.9.4";

  src = fetchFromGitHub {
    owner = "lizardfs";
    repo = "lizardfs";
    rev = "v.${version}";
    sha256 = "1vg33jy280apm4lp5dn3x51pkf7035ijqjm8wbmyha2g35gfjrlx";
  };

  # Manpages don't build in the current release
  buildInputs = [ cmake fuse /* asciidoc libxml2.bin */ zlib boost pkgconfig judy pam makeWrapper ];

  # Fixed in upcoming 3.10.0
  patches = [ ./check-includes.patch ];

  postInstall = ''
    wrapProgram $out/sbin/lizardfs-cgiserver \
        --prefix PATH ":" "${python}/bin"

    # mfssnapshot and mfscgiserv are deprecated
    rm -f $out/bin/mfssnapshot $out/sbin/mfscgiserv
  '';

  meta = with stdenv.lib; {
    homepage = https://lizardfs.com;
    description = "A highly reliable, scalable and efficient distributed file system";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = [ maintainers.rushmorem ];
  };
}
