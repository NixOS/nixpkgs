{ stdenv, fetchurl, cmake, mesa, SDL, libjpeg, libpng, glew, libwebp, ncurses
, gmp, curl, nettle, openal, speex, libogg, libvorbis, libtheora, xvidcore
, makeWrapper }:
stdenv.mkDerivation rec {
  name = "unvanquished-${version}";
  version = "0.13.1";
  src = fetchurl {
    url = "https://github.com/Unvanquished/Unvanquished/archive/v${version}.tar.gz";
    sha256 = "1k7mlpwalimn6xb2s760f124xncpg455qvls6z3x0ii5x0wc1mp2";
  };
  buildInputs = [ cmake mesa SDL libjpeg libpng glew libwebp ncurses gmp curl
                  nettle openal speex libogg libvorbis libtheora xvidcore 
                  makeWrapper ];
  preConfigure = ''prefix="$prefix/opt"'';
  postInstall = ''
    # cp -r ../main "$prefix/Unvanquished/"
    mkdir -p "$out/bin"
    substituteInPlace download-pk3.sh --replace /bin/bash ${stdenv.shell}
    cp -v download-pk3.sh "$out/bin/unvanquished-download-pk3"
    makeWrapper "$prefix/Unvanquished/daemon" "$out/bin/unvanquished" \
                --run '[ -f ~/.Unvanquished/main/md5sums ] &&
                       cd ~/.Unvanquished/main/ &&
                       md5sum --quiet -c md5sums ||
                       unvanquished-download-pk3' \
                --run "cd '$prefix/Unvanquished'"
    makeWrapper "$prefix/Unvanquished/daemonded" "$out/bin/unvanquished-ded" \
                --run '[ -f ~/.Unvanquished/main/md5sums ] &&
                       cd ~/.Unvanquished/main/ &&
                       md5sum --quiet -c md5sums ||
                       unvanquished-download-pk3' \
                --run "cd '$prefix/Unvanquished'"
  '';

  meta = {
    description = "FPS game set in a futuristic, sci-fi setting";
    longDescription = ''
      Unvanquished is a free, open-source first-person shooter
      combining real-time strategy elements with a futuristic, sci-fi
      setting. It is available for Windows, Linux, and macOS.

      Features:

      * Two teams
        Play as either the technologically advanced humans or the highly
        adaptable aliens, with a fresh gameplay experience on both
        sides.

      * Build a base
        Construct and maintain your base with a variety of useful
        structures, or group up with teammates to take on the other
        team.

      * Level up
        Earn rewards for victories against the other team, whether it's
        a deadly new weapon or access to a whole new alien form.

      * Customize
        Compatibility with Quake 3 file formats and modification tools
        allows for extensive customization of the game and its
        setting.
    '';
    homepage = http://unvanquished.net;
    #license = "unknown";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
    # This package can take a lot of disk space, so unavailable from channel
    hydraPlatforms = [];
  };
}
