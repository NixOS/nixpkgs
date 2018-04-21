{ stdenv, fetchurl, zlib, protobuf, ncurses, pkgconfig, IOTty
, makeWrapper, perl, openssl, autoreconfHook, openssh, bash-completion }:

stdenv.mkDerivation rec {
  name = "mosh-1.3.2";

  src = fetchurl {
    url = "https://mosh.org/${name}.tar.gz";
    sha256 = "05hjhlp6lk8yjcy59zywpf0r6s0h0b9zxq0lw66dh9x8vxrhaq6s";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ protobuf ncurses zlib IOTty makeWrapper perl openssl bash-completion ];

  patches = [ ./ssh_path.patch ];
  postPatch = ''
    substituteInPlace scripts/mosh.pl \
        --subst-var-by ssh "${openssh}/bin/ssh"
  '';

  configureFlags = [ "--enable-completion" ];

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
