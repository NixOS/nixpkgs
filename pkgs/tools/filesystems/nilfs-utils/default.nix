{ lib, stdenv, fetchFromGitHub, autoreconfHook, libuuid, libselinux
, e2fsprogs }:

stdenv.mkDerivation rec {
  pname = "nilfs-utils";
  version = "2.2.9";

  src = fetchFromGitHub {
    owner = "nilfs-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XqViUvPj2BHO3bGs9xBO3VpRq9XqnwBptHvMwBOntqo=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libuuid libselinux ];

  postPatch = ''
    # Fix up hardcoded paths.
    substituteInPlace lib/cleaner_exec.c --replace /sbin/ $out/bin/
    substituteInPlace sbin/mkfs/mkfs.c --replace /sbin/ ${lib.getBin e2fsprogs}/bin/
  '';

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
    license =  with licenses; [ gpl2 lgpl21 ];
    downloadPage = "http://nilfs.sourceforge.net/en/download.html";
  };
}
