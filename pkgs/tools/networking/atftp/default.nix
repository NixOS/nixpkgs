{ lib, stdenv, fetchurl, readline, tcp_wrappers, pcre, makeWrapper }:
assert stdenv.isLinux;
assert stdenv.gcc.gcc != null;
let
version = "0.7";
debianPatch = fetchurl {
  url = "mirror://debian/pool/main/a/atftp/atftp_${version}.dfsg-11.diff.gz";
  sha256 = "07g4qbmp0lnscg2dkj6nsj657jaghibvfysdm1cdxcn215n3zwqd";
};
in
stdenv.mkDerivation {
  name = "atftp";
  inherit version;
  src = fetchurl {
    url = "mirror://debian/pool/main/a/atftp/atftp_${version}.dfsg.orig.tar.gz";
    sha256 = "0nd5dl14d6z5abgcbxcn41rfn3syza6s57bbgh4aq3r9cxdmz08q";
  };
  buildInputs = [ readline tcp_wrappers pcre makeWrapper ];
  patches = [ debianPatch ];
  postInstall = ''
    wrapProgram $out/sbin/atftpd --prefix LD_LIBRARY_PATH : ${stdenv.gcc.gcc}/lib${if stdenv.system == "x86_64-linux" then "64" else ""}
  '';
  meta = {
    description = "Advanced tftp tools";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    passthru = {
      updateInfo = {
      downloadPage = "http://packages.debian.org/source/wheezy/atftp";
    };
  };
};
}
