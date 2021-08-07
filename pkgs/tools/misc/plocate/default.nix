{ stdenv
, lib
, fetchgit
, pkg-config
, meson
, ninja
, systemd
, liburing
, zstd
}:

stdenv.mkDerivation rec {
  pname = "plocate";
  version = "1.1.7";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = version;
    sha256 = "sha256-5Ie4qgiKUoI9Kma6YvjXirvBbpbKVuaMSSAZa36zN3M=";
  };

  postPatch = ''
    sed -i meson.build \
      -e "s@unitdir =.*@unitdir = '$out/lib/systemd/system'@" \
      -e '/mkdir\.sh/d'
  '';

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ systemd liburing zstd ];

  mesonFlags = [
    # I don't know why we can't do this but instead have to resort to patching meson.build
    #   "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dsharedstatedir=/var/lib"
  ];

  meta = with lib; {
    description = "Much faster locate";
    homepage = "https://plocate.sesse.net/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
