{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, glib
, libkrb5
, libnl
, libtool
, pkg-config
, withKerberos ? false
}:

stdenv.mkDerivation rec {
  pname = "ksmbd-tools";
  version = "3.4.7";

  src = fetchFromGitHub {
    owner = "cifsd-team";
    repo = pname;
    rev = version;
    sha256 = "sha256-uYJhjxarAqJC/aY8UUy7sjhA89LVoCG6B7/APkE0ouk=";
  };

  buildInputs = [ glib libnl ] ++ lib.optional withKerberos libkrb5;

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  preConfigure = "./autogen.sh";

  configureFlags = lib.optional withKerberos "--enable-krb5";

  meta = with lib; {
    description = "Userspace utilities for the ksmbd kernel SMB server";
    homepage = "https://www.kernel.org/doc/html/latest/filesystems/cifs/ksmbd.html";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elohmeier ];
  };
}
