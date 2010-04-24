{ stdenv, fetchurl, pam, gnutls, libnscd }:

stdenv.mkDerivation rec {
  name = "pwdutils-3.2.6";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/net/NIS/${name}.tar.bz2";
    sha256 = "1pyawvv9x0hiachn1mb257s6hm92dh1ykczgp7ik8z6jl020z3n7";
  };

  buildInputs = [ pam gnutls libnscd ];

  patchPhase =
    '' for i in src/tst-*
       do
         sed -i "$i" -e's|/bin/bash|/bin/sh|g'
       done
    '';

  configurePhase =
    '' ./configure --prefix="$out" --exec-prefix="$out/bin" \
                   --libdir="$out/lib" --disable-static     \
                   --disable-ldap --enable-gnutls
    '';

  # FIXME: The test suite seems to make assumptions that don't hold in Nix
  # chroots.
  doCheck = false;

  meta = {
    description = "Linux pwdutils, utilities to manage passwd information";

    longDescription =
      '' Pwdutils is a collection of utilities to manage the passwd
         information stored in local files, NIS, NIS+ or LDAP and can replace
         the shadow suite complete.
      '';

    license = "GPLv2";

    platforms = stdenv.lib.platforms.linux;
  };
}
