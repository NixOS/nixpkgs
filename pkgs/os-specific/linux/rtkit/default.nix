{ stdenv, fetchurl, fetchpatch, pkgconfig, dbus, libcap }:

stdenv.mkDerivation rec {
  name = "rtkit-0.11";

  src = fetchurl {
    url = "http://0pointer.de/public/${name}.tar.xz";
    sha256 = "1l5cb1gp6wgpc9vq6sx021qs6zb0nxg3cn1ba00hjhgnrw4931b8";
  };

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
  ];

  patches = [
    # Drop removed ControlGroup stanza
    (fetchpatch {
      url = "http://git.0pointer.net/rtkit.git/patch/?id=6c28e20c0be2f616a025059fda0ffac84e7f4f17";
      sha256 = "0lsxk5nv08i1wjb4xh20i5fcwg3x0qq0k4f8bc0r9cczph2sv7ck";
    })

    # security patch: Pass uid of caller to polkit
    (fetchpatch {
      url = "http://git.0pointer.net/rtkit.git/patch/?id=88d4082ef6caf6b071d749dca1c50e7edde914cc";
      sha256 = "0hp1blbi359qz8fmr6nj4w9yc0jf3dd176f8pn25wdj38n13qkix";
    })

    # Fix format string errors due to -Werror=format-security
    (fetchpatch {
      url = "https://sources.debian.org/data/main/r/rtkit/0.11-6/debian/patches/0006-fix-format-strings.patch";
      sha256 = "09mr89lh16jvz6cqw00zmh0xk919bjfhjkvna1czwmafwy9p7kgp";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus libcap ];
  NIX_LDFLAGS = "-lrt";

  meta = with stdenv.lib; {
    homepage = http://0pointer.de/blog/projects/rtkit;
    description = "A daemon that hands out real-time priority to processes";
    license = with licenses; [ gpl3 bsd0 ]; # lib is bsd license
    platforms = platforms.linux;
  };
}
