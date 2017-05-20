{ stdenv, fetchurl, zlib, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl, openssl, autoreconfHook, openssh }:

stdenv.mkDerivation rec {
  name = "mosh-1.3.0";

  src = fetchurl {
    url = "https://mosh.org/${name}.tar.gz";
    sha256 = "0xikz40q873g9ihvz3x6bwkcb9hb8kcnp5wpcmb72pg5c7s143ij";
  };

  buildInputs = [ autoreconfHook protobuf ncurses zlib pkgconfig IOTty makeWrapper perl openssl ];

  patches = [ ./ssh_path.patch ];
  postPatch = ''
    substituteInPlace scripts/mosh.pl \
        --subst-var-by ssh "${openssh}/bin/ssh"
  '';

  postInstall = ''
      wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  meta = {
    homepage = https://mosh.org/;
    description = "Mobile shell (ssh replacement)";
    longDescription = ''
      Remote terminal application that allows roaming, supports intermittent
      connectivity, and provides intelligent local echo and line editing of
      user keystrokes.

      Mosh is a replacement for SSH. It's more robust and responsive,
      especially over Wi-Fi, cellular, and long-distance links.
    '';
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.unix;
  };
}
