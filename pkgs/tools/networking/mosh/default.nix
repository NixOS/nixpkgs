{ lib, stdenv, fetchurl, fetchpatch, zlib, protobuf, ncurses, pkgconfig
, makeWrapper, perlPackages, openssl, autoreconfHook, openssh, bash-completion
, libutempter ? null, withUtempter ? stdenv.isLinux }:

stdenv.mkDerivation rec {
  name = "mosh-1.3.2";

  src = fetchurl {
    url = "https://mosh.org/${name}.tar.gz";
    sha256 = "05hjhlp6lk8yjcy59zywpf0r6s0h0b9zxq0lw66dh9x8vxrhaq6s";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ protobuf ncurses zlib makeWrapper openssl bash-completion ]
    ++ (with perlPackages; [ perl IOTty ])
    ++ lib.optional withUtempter libutempter;

  patches = [
    ./ssh_path.patch
    ./utempter_path.patch
    # Fix w/c++17, ::bind vs std::bind
    (fetchpatch {
      url = "https://github.com/mobile-shell/mosh/commit/e5f8a826ef9ff5da4cfce3bb8151f9526ec19db0.patch";
      sha256 = "15518rb0r5w1zn4s6981bf1sz6ins6gpn2saizfzhmr13hw4gmhm";
    })
  ];
  postPatch = ''
    substituteInPlace scripts/mosh.pl \
        --subst-var-by ssh "${openssh}/bin/ssh"
  '';

  configureFlags = [ "--enable-completion" ] ++ lib.optional withUtempter "--with-utempter";

  postInstall = ''
      wrapProgram $out/bin/mosh --prefix PERL5LIB : $PERL5LIB
  '';

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11";

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
