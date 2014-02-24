{ fetchurl, stdenv, bison, flex, pam,
  gcc, coreutils, findutils, binutils, bash }:

stdenv.mkDerivation rec {
  name    = "gradm-${version}";
  version = "3.0-201401291757";

  src  = fetchurl {
    url    = "http://grsecurity.net/stable/${name}.tar.gz";
    sha256 = "19p7kaqbvf41scc63n69b5v5xzpw3mbf5zy691rply8hdm7736cw";
  };

  buildInputs = [ gcc coreutils findutils binutils pam flex bison bash ];
  preBuild = ''
    substituteInPlace ./Makefile --replace "/usr/include/security/pam_" "${pam}/include/security/pam_"
    substituteInPlace ./gradm_defs.h --replace "/sbin/grlearn"   "$out/sbin/grlearn"
    substituteInPlace ./gradm_defs.h --replace "/sbin/gradm"     "$out/sbin/gradm"
    substituteInPlace ./gradm_defs.h --replace "/sbin/gradm_pam" "$out/sbin/gradm_pam"
  '';

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cat > $out/lib/udev/rules.d/80-grsec.rules <<EOF
    ACTION!="add|change", GOTO="permissions_end"
    KERNEL=="grsec",          MODE="0622"
    LABEL="permissions_end"
    EOF
  '';

  makeFlags =
    [ "DESTDIR=$(out)"
      "CC=${gcc}/bin/gcc"
      "FLEX=${flex}/bin/flex"
      "BISON=${bison}/bin/bison"
      "FIND=${findutils}/bin/find"
      "STRIP=${binutils}/bin/strip"
      "INSTALL=${coreutils}/bin/install"
      "MANDIR=/share/man"
      "MKNOD=true"
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "grsecurity RBAC administration and policy analysis utility";
    homepage    = "https://grsecurity.net";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wizeman ];
  };
}
