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
<<<<<<< HEAD
  version = "3.4.9";
=======
  version = "3.4.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cifsd-team";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-GZccOlp9zZMqtv3+u8JnKFfIe8sjwbZBLkDk8lt3CGk=";
=======
    sha256 = "sha256-R/OWZekAGtDxE71MrzjWsdpaWGBu0c+VP0VkPro6GEo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
