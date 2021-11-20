{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, libuuid, libselinux }:

stdenv.mkDerivation rec {
  pname = "nilfs-utils";
  version = "2.2.8";

  src = fetchFromGitHub {
    owner = "nilfs-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "094mw7dsyppyiyzfdnf3f5hlkrh4bidk1kvvpn1kcvw5vn2xpfk7";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libuuid libselinux ];

  # According to upstream, libmount should be detected automatically but the
  # build system fails to do this. This is likely a bug with their build system
  # hence it is explicitly enabled here.
  configureFlags = [ "--with-libmount" ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "root_sbindir=${placeholder "out"}/sbin"
  ];

  # FIXME: https://github.com/NixOS/patchelf/pull/98 is in, but stdenv
  # still doesn't use it
  #
  # To make sure patchelf doesn't mistakenly keep the reference via
  # build directory
  postInstall = ''
    find . -name .libs -exec rm -rf -- {} +
  '';

  meta = with lib; {
    description = "NILFS utilities";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl21 ];
    downloadPage = "http://nilfs.sourceforge.net/en/download.html";
    updateWalker = true;
  };
}
