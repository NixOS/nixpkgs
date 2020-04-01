{ stdenv, fetchurl
, bison, flex
, pam
}:

stdenv.mkDerivation rec {
  pname = "gradm";
  version = "3.1-201903191516";

  src  = fetchurl {
    url    = "http://grsecurity.net/stable/${pname}-${version}.tar.gz";
    sha256 = "1wszqwaswcf08s9zbvnqzmmfdykyfcy16w8xjia20ypr7wwbd86k";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ pam ];

  enableParallelBuilding = true;

  makeFlags = [
    "DESTDIR=$(out)"
    "LEX=${flex}/bin/flex"
    "MANDIR=/share/man"
    "MKNOD=true"
  ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace "/usr/bin/" "" \
      --replace "/usr/include/security/pam_" "${pam}/include/security/pam_"

    substituteInPlace gradm_defs.h \
      --replace "/sbin/grlearn" "$out/bin/grlearn" \
      --replace "/sbin/gradm" "$out/bin/gradm" \
      --replace "/sbin/gradm_pam" "$out/bin/gradm_pam"

    echo 'inherit-learn /nix/store' >>learn_config

    mkdir -p "$out/etc/udev/rules.d"
  '';

  postInstall = ''rmdir $out/dev'';

  meta = with stdenv.lib; {
    description = "grsecurity RBAC administration and policy analysis utility";
    homepage    = "https://grsecurity.net";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice joachifm ];
  };
}
