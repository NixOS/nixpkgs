{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config
, acl, librsync, ncurses, openssl, zlib, uthash }:

stdenv.mkDerivation rec {
  pname = "burp";
  version = "2.2.18";

  src = fetchFromGitHub {
    owner = "grke";
    repo = "burp";
    rev = version;
    sha256 = "1zhq240kz881vs2s620qp0kifmgr582caalm85ls789w9rmdkhjl";
  };

  patches = [
    # Pull upstream fix for ncurses-6.3 support
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/grke/burp/commit/1d6c931af7c11f164cf7ad3479781e8f03413496.patch";
      sha256 = "14sfbfahlankz3xg6v10i8fnmpnmqpp73q9xm0l0hnjh25igv6bl";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ librsync ncurses openssl zlib uthash ]
    ++ lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [ "--localstatedir=/var" ];

  installFlags = [ "localstatedir=/tmp" ];

  meta = with lib; {
    description = "BURP - BackUp and Restore Program";
    homepage    = "https://burp.grke.org";
    license     = licenses.agpl3;
    maintainers = with maintainers; [ tokudan ];
    platforms   = platforms.all;
  };
}
