{ lib, stdenv, fetchurl
, bison, flex
, pam
}:

stdenv.mkDerivation rec {
  pname = "gradm";
  version = "3.1-202102241600";

  src  = fetchurl {
    url    = "https://grsecurity.net/stable/${pname}-${version}.tar.gz";
    sha256 = "02ni34hpggv00140p9gvh0lqi173zdddd2qhfi96hyr1axd5pl50";
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
      --replace-fail "/usr/bin/" "" \
      --replace-fail "/usr/include/security/pam_" "${pam}/include/security/pam_"

    substituteInPlace gradm_defs.h \
      --replace-fail "/sbin/grlearn" "$out/bin/grlearn" \
      --replace-fail "/sbin/gradm" "$out/bin/gradm" \
      --replace-fail "/sbin/gradm_pam" "$out/bin/gradm_pam"

    echo 'inherit-learn /nix/store' >>learn_config

    mkdir -p "$out/etc/udev/rules.d"
  '';

  postInstall = "rmdir $out/dev";

  meta = with lib; {
    description = "grsecurity RBAC administration and policy analysis utility";
    homepage    = "https://grsecurity.net";
    license     = licenses.gpl2Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice joachifm ];
  };
}
