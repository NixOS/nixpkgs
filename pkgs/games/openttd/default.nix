{ stdenv, fetchurl, fetchzip, pkgconfig, SDL, libpng, zlib, xz, freetype, fontconfig
, withOpenGFX ? true, withOpenSFX ? true, withOpenMSX ? true
}:

let
  opengfx = fetchzip {
    url = "http://binaries.openttd.org/extra/opengfx/0.5.2/opengfx-0.5.2-all.zip";
    sha256 = "1sjzwl8wfdj0izlx2qdq15bqiy1vzq7gq7drydfwwryk173ig5sa";
  };

  opensfx = fetchzip {
    url = "http://binaries.openttd.org/extra/opensfx/0.2.3/opensfx-0.2.3-all.zip";
    sha256 = "1bb167kszdd6dqbcdjrxxwab6b7y7jilhzi3qijdhprpm5gf1lp3";
  };

  openmsx = fetchzip {
    url = "http://binaries.openttd.org/extra/openmsx/0.3.1/openmsx-0.3.1-all.zip";
    sha256 = "0qnmfzz0v8vxrrvxnm7szphrlrlvhkwn3y92b4iy0b4b6yam0yd4";
  };

in
stdenv.mkDerivation rec {
  name = "openttd-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "http://binaries.openttd.org/releases/${version}/${name}-source.tar.xz";
    sha256 = "1cjf9gz7d0sn7893wv9d00q724sxv3d81bgb0c5f5ppz2ssyc4jc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ SDL libpng xz zlib freetype fontconfig ];

  prefixKey = "--prefix-dir=";

  configureFlags = [
    "--without-liblzo2"
  ];

  makeFlags = "INSTALL_PERSONAL_DIR=";

  postInstall = ''
    mv $out/games/ $out/bin

    ${stdenv.lib.optionalString withOpenGFX ''
      cp ${opengfx}/* $out/share/games/openttd/baseset
    ''}

    mkdir -p $out/share/games/openttd/data

    ${stdenv.lib.optionalString withOpenSFX ''
      cp ${opensfx}/*.{obs,cat} $out/share/games/openttd/data
    ''}

    ${stdenv.lib.optionalString withOpenMSX ''
      cp ${openmsx}/*.{obm,mid} $out/share/games/openttd/data
    ''}
  '';

  meta = {
    description = ''Open source clone of the Microprose game "Transport Tycoon Deluxe"'';
    longDescription = ''
      OpenTTD is a transportation economics simulator. In single player mode,
      players control a transportation business, and use rail, road, sea, and air
      transport to move goods and people around the simulated world.

      In multiplayer networked mode, players may:
        - play competitively as different businesses
        - play cooperatively controlling the same business
        - observe as spectators
    '';
    homepage = http://www.openttd.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ jcumming the-kenny fpletz ];
  };
}
