{ lib, newScope, fetchzip, python3Packages }:
lib.makeScope newScope (self: with self; {
  script-trakt = mkKodiPlugin {
    plugin = "script-trakt";
    namespace = "script.trakt";
    version = "3.3.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.trakt/script.trakt-3.3.5.zip";
      sha256 = "0icisa05hxys0w2a05yjc44wffs5g899gm3rbzlpyygwlj8kijjv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-trakt # version 4.1.0
      script-module-dateutil # version 2.4.2
    ];
    meta = with lib; {
      description = "Kodi addon: Trakt";
      longDescription = ''
        Automatically scrobble all TV episodes and movies you are watching to Trakt.tv! Keep a comprehensive history of everything you've watched and be part of a global community of TV and movie enthusiasts. Sign up for a free account at http://trakt.tv and get a ton of features:

        - Automatically scrobble what you're watching
        - Mobile apps for iPhone, iPad, Android, and Windows Phone
        - Share what you're watching (in real time) and rating to facebook and twitter
        - Personalized calendar so you never miss a TV show
        - Follow your friends and people you're interesed in
        - Use watchlists so you don't forget to what to watch
        - Track your media collections and impress your friends
        - Create custom lists around any topics you choose
        - Easily track your TV show progress across all seasons and episodes
        - Track your progress against industry lists such as the IMDb Top 250
        - Discover new shows and movies based on your viewing habits
        - Widgets for your forum signature

        What can this addon do?

        - Automatically scrobble all TV episodes and movies you are watching
        - Sync your TV episode and movie collections to Trakt (triggered after a library update)
        - Auto clean your Trakt collection so that it matches up with Kodi
        - Keep watched statuses synced between Kodi and Trakt
        - Rate movies and episode after watching them

        Special thanks to all who contributed to this plugin! Check the commit history and changelog to see these talented developers.
      '';
      homepage = "https://trakt.tv";
      platform = platforms.all;
    };
  };
  plugin-video-viervijfzes = mkKodiPlugin {
    plugin = "plugin-video-viervijfzes";
    namespace = "plugin.video.viervijfzes";
    version = "0.4.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.viervijfzes/plugin.video.viervijfzes-0.4.1+matrix.1.zip";
      sha256 = "16cxcknqkd1680ipp9c1alns3dnfkf6asc5fvkay19p78d9ggw52";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.6.0
      script-module-inputstreamhelper # version 0.5.1
      script-module-requests # version 2.22.0
      script-module-routing # version 0.2.0
      inputstream-adaptive # version 2.4.3
    ];
    meta = with lib; {
      description = "Kodi addon: GoPlay";
      longDescription = ''
        This add-on gives access to video-on-demand content available on the websites of Play4, Play5 and Play6.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-vimeo = mkKodiPlugin {
    plugin = "plugin-video-vimeo";
    namespace = "plugin.video.vimeo";
    version = "6.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.vimeo/plugin.video.vimeo-6.0.0.zip";
      sha256 = "1181hny98kpbdvmm1ifx6amq2mfscazcv0kaqm8xw21g68ll2x00";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Vimeo";
      homepage = "https://vimeo.com";
      platform = platforms.all;
    };
  };
  plugin-video-raitv = mkKodiPlugin {
    plugin = "plugin-video-raitv";
    namespace = "plugin.video.raitv";
    version = "3.6.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.raitv/plugin.video.raitv-3.6.0.zip";
      sha256 = "0vjy6znbwjl0q3h9rix88aymwijmxlgff1kjn7n8mibn4f18dnrf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-common-plugin-cache # version 2.6.0
      script-module-inputstreamhelper # version None
    ];
    meta = with lib; {
      description = "Kodi addon: Rai Play";
      longDescription = ''
        Live radio and TV channels, latest 7 days of programming, broadcast archive, news.
        Source: https://github.com/maxbambi/plugin.video.raitv/
      '';
      homepage = "https://github.com/maxbambi/plugin.video.raitv/";
      platform = platforms.all;
    };
  };
  plugin-video-catchuptvandmore = mkKodiPlugin {
    plugin = "plugin-video-catchuptvandmore";
    namespace = "plugin.video.catchuptvandmore";
    version = "0.2.32+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.catchuptvandmore/plugin.video.catchuptvandmore-0.2.32+matrix.1.zip";
      sha256 = "04agm3i9lnzg3c7bwfn1jnjkm75lm4x8ia3cfsmz75aswpmvacnv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-codequick # version 0.9.13
      script-module-youtube-dl # version 18.225.0
      script-module-requests # version 2.12.4
      script-module-pytz # version 2014.2
      script-module-inputstreamhelper # version 0.3.3
      script-module-six # version 1.11.0
      script-module-pyqrcode # version 0.0.1
      script-module-tzlocal # version 2.0.0
      script-module-future # version 0.17.1
      script-module-kodi-six # version 0.0.4
      resource-images-catchuptvandmore # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Catch-up TV & More";
      longDescription = ''
        Catch-Up TV & More brings together in one Kodi add-on all the videos of the various services and channels of catch-up TV and live TV. Furthermore, this add-on allows you to quickly access the videos and content offered by certain websites.
      '';
      homepage = "https://catch-up-tv-and-more.github.io/";
      platform = platforms.all;
    };
  };
  plugin-video-sarpur = mkKodiPlugin {
    plugin = "plugin-video-sarpur";
    namespace = "plugin.video.sarpur";
    version = "5.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.sarpur/plugin.video.sarpur-5.0.zip";
      sha256 = "0l2k1r92z344lka39ijw5wmqw53g20sz22annp3l6z3p0id42vrr";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.3.0
    ];
    meta = with lib; {
      description = "Kodi addon: Sarpur";
      longDescription = ''
        An Icelandic IP-Address is required to use this because of geoblocking
      '';
      homepage = "https://github.com/Dagur/sarpur-xbmc";
      platform = platforms.all;
    };
  };
  script-module-codequick = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-codequick";
    namespace = "script.module.codequick";
    version = "1.0.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.codequick/script.module.codequick-1.0.1+matrix.1.zip";
      sha256 = "1y2pr0gmvpnbwhj5gfjirnrh3r0yi2fxmdbirl2ydfnprpxw50kh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-youtube-dl # version 19.912.1
      script-module-htmlement # version 1.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: CodeQuick";
      longDescription = ''
        Codequick is a framework for kodi add-on's. The goal of this framework is to simplify add-on development. This is achieved by reducing the amount of boilerplate code to a minimum, automating tasks like route dispatching and sort method selection. Ultimately allowing the developer to focus primarily on scraping content from websites and passing it to kodi.
      '';
      platform = platforms.all;
    };
  });
  service-subtitles-subsceneplus = mkKodiPlugin {
    plugin = "service-subtitles-subsceneplus";
    namespace = "service.subtitles.subsceneplus";
    version = "1.1.27";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.subsceneplus/service.subtitles.subsceneplus-1.1.27.zip";
      sha256 = "1nqx2jx4bjy7vp2h6myc5rk31qhz1q4fna4inq5qjl3lcmgz980b";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-html5lib # version 1.0.1+matrix.2
      vfs-libarchive # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Subscene Subtitles";
      longDescription = ''
        A convenient addon to download subtitles from subscene.com. If you find it useful, please consider giving it a star in github. This is being actively maintained. In case of any problem, feel free to open an issue on github.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-youtube = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "plugin-video-youtube";
    namespace = "plugin.video.youtube";
    version = "6.8.10+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.youtube/plugin.video.youtube-6.8.10+matrix.1.zip";
      sha256 = "18z9zh6yqihnmfwd6cc4kpy2frzbarvhg8qpyc3w851ad053q7v0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.11.0
      script-module-requests # version 2.12.4
    ];
    meta = with lib; {
      description = "Kodi addon: YouTube";
      longDescription = ''
        YouTube is one of the biggest video-sharing websites of the world.
      '';
      homepage = "https://www.youtube.com";
      platform = platforms.all;
    };
  });
  script-cu-lrclyrics = mkKodiPlugin {
    plugin = "script-cu-lrclyrics";
    namespace = "script.cu.lrclyrics";
    version = "6.3.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.cu.lrclyrics/script.cu.lrclyrics-6.3.9.zip";
      sha256 = "1sjp96z3jxc8y7z85kzkcb58i1dq0ik9jznhlb90aqbz6429wsxh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.8.2+matrix.1
      script-module-chardet # version 3.0.4+matrix.1
      script-module-mutagen # version 1.44.0+matrix.1
      script-module-requests # version 2.22.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: CU LRC Lyrics";
      longDescription = ''
        CU LRC Lyrics is a lyrics script for Kodi. It supports regular as well as LRC Lyrics. The script can search synchronized/unsynchronized lyrics embedded, from file or by scrapers. It can read .lrc/.txt lyrics file saved at the same path by same file name with .mp3(or other type of music).
      '';
      platform = platforms.all;
    };
  };
  resource-images-retrospect = mkKodiPlugin {
    plugin = "resource-images-retrospect";
    namespace = "resource.images.retrospect";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.retrospect/resource.images.retrospect-1.0.9.zip";
      sha256 = "106x8jfziazv5rlf8rya8glkw8dd1i0dri408809n23ard144n71";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Retrospect channel logos and artwork";
      longDescription = ''
        Artwork and logos for the channels in Retrospect.
      '';
      platform = platforms.all;
    };
  };
  script-module-t1mlib = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-t1mlib";
    namespace = "script.module.t1mlib";
    version = "4.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.t1mlib/script.module.t1mlib-4.0.7.zip";
      sha256 = "1012praxnm2va0w3kly5psrrbs4ycwi0by73l5d85dyfpc237lwm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: t1m Library Routines";
      longDescription = ''
        t1m Library Routines
      '';
      platform = platforms.all;
    };
  });
  screensaver-bing = mkKodiPlugin {
    plugin = "screensaver-bing";
    namespace = "screensaver.bing";
    version = "1.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.bing/screensaver.bing-1.0.4.zip";
      sha256 = "11qr8yv4a8hib7hkbmqk3jy0pmqzr4r351ckdl4wnnjxfbp0m5pc";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.7.0
      script-module-simplecache # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Bing: Photos of the Week";
      longDescription = ''
        Explore breathtaking images from the Bing homepage...
      '';
      platform = platforms.all;
    };
  };
  script-video-randomtv = mkKodiPlugin {
    plugin = "script-video-randomtv";
    namespace = "script.video.randomtv";
    version = "1.3.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.video.randomtv/script.video.randomtv-1.3.0.zip";
      sha256 = "1b56b37f41b31r7fiavvvs9fi8ar480vhvvlp8gyj236hd7kalh9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: RandomTV";
      longDescription = ''
        RandomTV plays random TV episodes from your library.
        There are a few options:
        - Include unwatched episodes (only watched will be included by default)
        - Update Play Count
        - Repeat Playlist
        - Shuffle On Repeat
        - Show Notifications
        - Enable Auto Stop
        - Include All TV Shows or Select TV Shows
        It will also add a context menu item so that you can play a specific show or season with RandomTV
      '';
      platform = platforms.all;
    };
  };
  screensaver-videosaver = mkKodiPlugin {
    plugin = "screensaver-videosaver";
    namespace = "screensaver.videosaver";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.videosaver/screensaver.videosaver-1.0.9.zip";
      sha256 = "1rzz1k72i95ffmyqvmqda70mg3wrrmm6k1sqv8bkv31lsxlm4rvm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-simplecache # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Video ScreenSaver";
      longDescription = ''
        Dynamic screensaver using Local content, SmartPlaylists, Plugins and UPNP Servers.
      '';
      platform = platforms.all;
    };
  };
  screensaver-google-earth = mkKodiPlugin {
    plugin = "screensaver-google-earth";
    namespace = "screensaver.google.earth";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.google.earth/screensaver.google.earth-1.0.8.zip";
      sha256 = "135f6d9yvign6h6rn5w7gqz7wiadyzlypw46a7lkclkc3f9k77si";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.7.0
      script-module-simplecache # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Google Earth";
      longDescription = ''
        Earth View is a collection of the most beautiful and striking landscapes found in Google Earth.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-arteplussept = mkKodiPlugin {
    plugin = "plugin-video-arteplussept";
    namespace = "plugin.video.arteplussept";
    version = "1.1.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.arteplussept/plugin.video.arteplussept-1.1.0.zip";
      sha256 = "1srpcbzc0mpj3j3r9rq3d5q9fn33rbw749rlc99zrqbwcqch18lb";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-xbmcswift2 # version 19.0.4
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Arte +7";
      longDescription = ''
        Watch videos from Arte +7
        For feature requests / issues:
        https://github.com/known-as-bmf/plugin.video.arteplussept/issues
        Contributions are welcome:
        https://github.com/known-as-bmf/plugin.video.arteplussept
      '';
      homepage = "https://www.arte.tv/fr/";
      platform = platforms.all;
    };
  };
  plugin-video-eitb = mkKodiPlugin {
    plugin = "plugin-video-eitb";
    namespace = "plugin.video.eitb";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.eitb/plugin.video.eitb-2.0.0.zip";
      sha256 = "00yy0dn00q5zd83xh0irs0adrhwjx1czf43824d764ghksryp5l1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: EITB Nahieran (unofficial)";
      longDescription = ''
        Plugin for EITB using the unofficial REST API
      '';
      homepage = "https://github.com/erral/plugin.video.eitb";
      platform = platforms.all;
    };
  };
  plugin-video-rtpplay = mkKodiPlugin {
    plugin = "plugin-video-rtpplay";
    namespace = "plugin.video.rtpplay";
    version = "5.0.13+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.rtpplay/plugin.video.rtpplay-5.0.13+matrix.1.zip";
      sha256 = "0nz9zv9n93p5apzmr3yd7hj2ilq0x3ih1jbn0lgax1h5v0v1jijp";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-routing # version 0.2.0
      script-module-requests # version 2.12.4
      script-module-inputstreamhelper # version 0.4.2
      script-module-beautifulsoup4 # version 4.6.2
    ];
    meta = with lib; {
      description = "Kodi addon: RTP Play";
      longDescription = ''
        Play live and on-demand broadcasts from RTP Play
      '';
      homepage = "http://rtp.pt/play";
      platform = platforms.all;
    };
  };
  script-module-youtube-dl = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-youtube-dl";
    namespace = "script.module.youtube.dl";
    version = "21.204.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.youtube.dl/script.module.youtube.dl-21.204.0+matrix.1.zip";
      sha256 = "0jz93kavxc4q44vpsg0rrw5z67hnh8836qlmb21hiym7alhl45sm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-addon-signals # version 0.0.5+matrix.1
      script-module-kodi-six # version 0.1.3
    ];
    meta = with lib; {
      description = "Kodi addon: youtube-dl Control";
      longDescription = ''
        Module providing access to youtube-dl video stream extraction for hundreds of sites. Version is based on youtube-dl date version: YY.MDD.V where V is the addon specific sub-version. Also provides downloading with the option for background downloading with a queue and queue manager.
      '';
      platform = platforms.all;
    };
  });
  plugin-video-mediathekview = mkKodiPlugin {
    plugin = "plugin-video-mediathekview";
    namespace = "plugin.video.mediathekview";
    version = "0.6.7+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.mediathekview/plugin.video.mediathekview-0.6.7+matrix.1.zip";
      sha256 = "1np6lv3c7hs5f9fx1jq16sqsmrgwnn67ars73xz0z629c22zaqp9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-myconnpy # version 1.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: MediathekView";
      longDescription = ''
        Gives access to most video-platforms from German public service broadcasters using the database of MediathekView.de
      '';
      homepage = "https://mediathekview.de/";
      platform = platforms.all;
    };
  };
  plugin-video-francetv = mkKodiPlugin {
    plugin = "plugin-video-francetv";
    namespace = "plugin.video.francetv";
    version = "2.0.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.francetv/plugin.video.francetv-2.0.1+matrix.1.zip";
      sha256 = "0arwvlh5qxqzn9q9r71dpvh36fp1k9r99hb6zi9hkmacznx8f6qy";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.8.2
      script-module-inputstreamhelper # version 0.5.1
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: france.tv";
      longDescription = ''
        Live and catchup TV for France Télévisions channels
      '';
      homepage = "https://www.france.tv/";
      platform = platforms.all;
    };
  };
  screensaver-unsplash = mkKodiPlugin {
    plugin = "screensaver-unsplash";
    namespace = "screensaver.unsplash";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.unsplash/screensaver.unsplash-1.0.7.zip";
      sha256 = "1pmczfw3wkddxz2247hql9ah63ixl8nwxjiys5cl81536z2ch7s4";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.7.0
    ];
    meta = with lib; {
      description = "Kodi addon: Unsplash Photo Screensaver";
      longDescription = ''
        Beautiful, free photos. Gifted by the world's most generous community of photographers.
      '';
      homepage = "https://unsplash.com/";
      platform = platforms.all;
    };
  };
  script-adzapper = mkKodiPlugin {
    plugin = "script-adzapper";
    namespace = "script.adzapper";
    version = "1.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.adzapper/script.adzapper-1.0.2.zip";
      sha256 = "1rwxg31paqpy4vmdr7m2hdb7418lsvcs9i7y2ykrhkp0c2biva93";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: LiveTV Ad-Zapper";
      longDescription = ''
        Add advertisment skipping to your Kodi system, allowing the user to define a time to switch back to the current channel. During this time the user can switch channel without thinking to switch back manually.
      '';
      homepage = "https://forum.kodi.tv/showthread.php?tid=329102";
      platform = platforms.all;
    };
  };
  skin-aeon-tajo = mkKodiPlugin {
    plugin = "skin-aeon-tajo";
    namespace = "skin.aeon.tajo";
    version = "3.6.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.aeon.tajo/skin.aeon.tajo-3.6.1.zip";
      sha256 = "1dd31sw4kxi1ar8jl2p4fhw45lrpzvlr8xana07lxvd3r1yyv0im";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
      script-skinshortcuts # version 0.4.5
      service-library-data-provider # version 0.0.7
      script-embuary-helper # version 2.0.6
      resource-images-studios-white # version 0.0.1
      resource-images-recordlabels-white # version 0.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Aeon Tajo";
      longDescription = ''
        Aeon Tajo: Changes everything so that nothing changes. Inspired on Aeon Nox 5 (thanks to BigNoid).
      '';
      homepage = "https://github.com/manfeed/skin.aeon.tajo";
      platform = platforms.all;
    };
  };
  plugin-video-videomediaset = mkKodiPlugin {
    plugin = "plugin-video-videomediaset";
    namespace = "plugin.video.videomediaset";
    version = "2.0.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.videomediaset/plugin.video.videomediaset-2.0.2+matrix.1.zip";
      sha256 = "1a4y6pmwlxhyk0i0drz4xch4i4kr879bbprg5j57sv0ymsjfa90x";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-phate89 # version 1.2.1
      script-module-inputstreamhelper # version 0.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Mediaset Play";
      longDescription = ''
        All your favorite shows are available to you the day after the airing Tv. Last night you missed your favorite TV drama? No problem, you can finally see her comfortably on KODI whenever you want.
      '';
      platform = platforms.all;
    };
  };
  service-stinger-notification = mkKodiPlugin {
    plugin = "service-stinger-notification";
    namespace = "service.stinger.notification";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.stinger.notification/service.stinger.notification-2.0.0.zip";
      sha256 = "0dly4qvvny9imh2gpmbvp59p7kbvm6yi3c9q7ha47cjlv7z5i267";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.9.1
    ];
    meta = with lib; {
      description = "Kodi addon: Stinger scene notification";
      longDescription = ''
        This add-on notifies you of stinger scenes in the current movie, popping up a notification when the credits roll. It uses tags to identify movies that have a stinger scene, which can be automatically added by the Universal Movie Scraper from The Movie Database.
      '';
      platform = platforms.all;
    };
  };
  resource-images-languageflags-flat = mkKodiPlugin {
    plugin = "resource-images-languageflags-flat";
    namespace = "resource.images.languageflags-flat";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.languageflags-flat/resource.images.languageflags-flat-0.0.1.zip";
      sha256 = "0nsd266d8ia621iralxai4z8c2c2c3hcbbwm51m2k13aiz6g420j";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Language Flags Colour Flat";
      longDescription = ''
        Flat coloured icons with rounded corners. Icons designed by Muharrem Senyil
      '';
      homepage = "https://dribbble.com/msenyil";
      platform = platforms.all;
    };
  };
  script-plex = mkKodiPlugin {
    plugin = "script-plex";
    namespace = "script.plex";
    version = "0.3.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.plex/script.plex-0.3.3.zip";
      sha256 = "1l8n9jls7wy9rwhfqlf02zhd369wv5jssy9x52mi8l42sxmjkvkk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-six # version 1.14.0+matrix.1
      script-module-kodi-six # version 0.1.3.1
    ];
    meta = with lib; {
      description = "Kodi addon: Plex";
      longDescription = ''
        Official Plex for Kodi add-on
      '';
      homepage = "https://www.plex.tv";
      platform = platforms.all;
    };
  };
  resource-language-tr_tr = mkKodiPlugin {
    plugin = "resource-language-tr_tr";
    namespace = "resource.language.tr_tr";
    version = "9.0.21";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.tr_tr/resource.language.tr_tr-9.0.21.zip";
      sha256 = "0r4mp6vr82yxcnwbqdhbh7202czq9i6jhmlrj2v0xnq4dnrjhwxw";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Turkish";
      longDescription = ''
        Turkish version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-vi_vn = mkKodiPlugin {
    plugin = "resource-language-vi_vn";
    namespace = "resource.language.vi_vn";
    version = "9.0.12";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.vi_vn/resource.language.vi_vn-9.0.12.zip";
      sha256 = "1y5gimgp24wq4zcsr3917q2njgay6ff960zhw7bqsiqqdagad1kb";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Vietnamese";
      longDescription = ''
        Vietnamese version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-fr_fr = mkKodiPlugin {
    plugin = "resource-language-fr_fr";
    namespace = "resource.language.fr_fr";
    version = "9.0.35";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.fr_fr/resource.language.fr_fr-9.0.35.zip";
      sha256 = "0kp4vfyzzcx0429vxfh0l78rh8fbpnnynirnpz3rgpmvmjlzwv33";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: French";
      longDescription = ''
        French version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ko_kr = mkKodiPlugin {
    plugin = "resource-language-ko_kr";
    namespace = "resource.language.ko_kr";
    version = "9.0.19";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ko_kr/resource.language.ko_kr-9.0.19.zip";
      sha256 = "05ff47z12h3pf42mp6gk3bbr31alqwhk22cp5y15kmrz9lv0bvc0";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Korean";
      longDescription = ''
        Korean version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-lt_lt = mkKodiPlugin {
    plugin = "resource-language-lt_lt";
    namespace = "resource.language.lt_lt";
    version = "9.0.27";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.lt_lt/resource.language.lt_lt-9.0.27.zip";
      sha256 = "1c5nzw7h39wc2w9yhbhz17s34325fdgnh7qdv5y2sd5vbsj56bf8";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Lithuanian";
      longDescription = ''
        Lithuanian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-pt_br = mkKodiPlugin {
    plugin = "resource-language-pt_br";
    namespace = "resource.language.pt_br";
    version = "9.0.33";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.pt_br/resource.language.pt_br-9.0.33.zip";
      sha256 = "1ybnxx1kvljkjrpvvw7mj5qvxx5cw59qf3k49q8bwmc9xlmgzfax";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Portuguese (Brazil)";
      longDescription = ''
        Portuguese (Brazil) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-pt_pt = mkKodiPlugin {
    plugin = "resource-language-pt_pt";
    namespace = "resource.language.pt_pt";
    version = "9.0.15";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.pt_pt/resource.language.pt_pt-9.0.15.zip";
      sha256 = "0krv9hfjw69sx1pyhvbsj6afwcv0b7l372w2w69dnp4jhx0h67mz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Portuguese";
      longDescription = ''
        Portuguese version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ru_ru = mkKodiPlugin {
    plugin = "resource-language-ru_ru";
    namespace = "resource.language.ru_ru";
    version = "9.0.24";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ru_ru/resource.language.ru_ru-9.0.24.zip";
      sha256 = "1nck2hklllravny3rdscq79fg07m2myqlrps3867y8mxpig00f50";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Russian";
      longDescription = ''
        Russian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-sk_sk = mkKodiPlugin {
    plugin = "resource-language-sk_sk";
    namespace = "resource.language.sk_sk";
    version = "9.0.26";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.sk_sk/resource.language.sk_sk-9.0.26.zip";
      sha256 = "1wy0g63d2wdrrc4w61r28apl9gy9yl870l52rdlshyl0r435fhx7";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Slovak";
      longDescription = ''
        Slovak version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-sv_se = mkKodiPlugin {
    plugin = "resource-language-sv_se";
    namespace = "resource.language.sv_se";
    version = "9.0.29";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.sv_se/resource.language.sv_se-9.0.29.zip";
      sha256 = "1rnfp3r88fy33884ncml7nxavihy8c3fmkbvh6zqq3i5mv76r96a";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Swedish";
      longDescription = ''
        Swedish version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-bg_bg = mkKodiPlugin {
    plugin = "resource-language-bg_bg";
    namespace = "resource.language.bg_bg";
    version = "9.0.31";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.bg_bg/resource.language.bg_bg-9.0.31.zip";
      sha256 = "0zq79hgdvcwc08cgsxcpb2jdmdd6dnpdaidhnb7w32ys9q7czpgd";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Bulgarian";
      longDescription = ''
        Bulgarian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ca_es = mkKodiPlugin {
    plugin = "resource-language-ca_es";
    namespace = "resource.language.ca_es";
    version = "9.0.13";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ca_es/resource.language.ca_es-9.0.13.zip";
      sha256 = "1927zkz4rc2803gyvzwyb2k13z23bhxknm7l79jav3hqlij4g0m9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Catalan";
      longDescription = ''
        Catalan version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-cs_cz = mkKodiPlugin {
    plugin = "resource-language-cs_cz";
    namespace = "resource.language.cs_cz";
    version = "9.0.31";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.cs_cz/resource.language.cs_cz-9.0.31.zip";
      sha256 = "1cjis8a8vw7im803nvrpnlsv98p1lkd61kwpydbcc5cyqwyn3csf";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Czech";
      longDescription = ''
        Czech version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-cy_gb = mkKodiPlugin {
    plugin = "resource-language-cy_gb";
    namespace = "resource.language.cy_gb";
    version = "9.0.12";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.cy_gb/resource.language.cy_gb-9.0.12.zip";
      sha256 = "1bbkss4nwzkm126vh0sdmhsdx25dpxnh7w9v2wm4h178slfh2g3v";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Welsh";
      longDescription = ''
        Welsh version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-de_de = mkKodiPlugin {
    plugin = "resource-language-de_de";
    namespace = "resource.language.de_de";
    version = "9.0.31";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.de_de/resource.language.de_de-9.0.31.zip";
      sha256 = "1prgkpza20kp2iilrmmz3givlqva84ny0sx3xlcq5yd7sh4cz898";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: German";
      longDescription = ''
        German version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-es_mx = mkKodiPlugin {
    plugin = "resource-language-es_mx";
    namespace = "resource.language.es_mx";
    version = "9.0.16";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.es_mx/resource.language.es_mx-9.0.16.zip";
      sha256 = "1x80aay8jf95xb1hlvgkxn23jys8y3lzbhv7gcvgkbqk1fpim56a";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Spanish (Mexico)";
      longDescription = ''
        Spanish (Mexico) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-fi_fi = mkKodiPlugin {
    plugin = "resource-language-fi_fi";
    namespace = "resource.language.fi_fi";
    version = "9.0.31";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.fi_fi/resource.language.fi_fi-9.0.31.zip";
      sha256 = "084nq58vhg7ilx898pdgi0chlna21p9s1s4rkmki9b37j8nffr2l";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Finnish";
      longDescription = ''
        Finnish version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  script-module-phate89 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-phate89";
    namespace = "script.module.phate89";
    version = "1.2.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.phate89/script.module.phate89-1.2.1+matrix.1.zip";
      sha256 = "0nbfnmv27z9x5ix4d8jvclm5qmbac0h330qqlifvn42dhm8sjgxm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.9.1
      script-module-beautifulsoup4 # version 4.3.1
      script-module-html5lib # version 0.999.0
    ];
    meta = with lib; {
      description = "Kodi addon: phate89 helper module";
      longDescription = ''
        Helper module for addons
      '';
      platform = platforms.all;
    };
  });
  service-upnext = mkKodiPlugin {
    plugin = "service-upnext";
    namespace = "service.upnext";
    version = "1.1.5+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.upnext/service.upnext-1.1.5+matrix.1.zip";
      sha256 = "06rgp7jbyl5knvpxdr8mhfl0dc4l8ll2l23mzpvcw09i5590bhbn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Up Next";
      longDescription = ''
        A service add-on that shows a Netflix-style notification for watching the next episode. After a few automatic iterations it asks the user if he is still there watching.

        A lot of existing add-ons already integrate with this service out-of-the-box.
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-kxmxpxtx-bandcamp = mkKodiPlugin {
    plugin = "plugin-audio-kxmxpxtx-bandcamp";
    namespace = "plugin.audio.kxmxpxtx.bandcamp";
    version = "0.4.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.kxmxpxtx.bandcamp/plugin.audio.kxmxpxtx.bandcamp-0.4.1+matrix.1.zip";
      sha256 = "0ydinxl09lgmlcfar7hfpwi0bmn9yv34j9076zxyqm8nvjy5y1h4";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-future # version 0.18.2+matrix.1
      script-common-plugin-cache # version 2.6.1.1
    ];
    meta = with lib; {
      description = "Kodi addon: Bandcamp";
      longDescription = ''
        Discover new artists and browse your collection
      '';
      platform = platforms.all;
    };
  };
  plugin-video-rocketbeans = mkKodiPlugin {
    plugin = "plugin-video-rocketbeans";
    namespace = "plugin.video.rocketbeans";
    version = "1.2.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.rocketbeans/plugin.video.rocketbeans-1.2.3.zip";
      sha256 = "1z8faxy00ia2mzx6i6mk83b2vnv9y4z1vma3n9gf65lf0c8dmkdj";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      plugin-video-youtube # version 5.2.1
      plugin-video-twitch # version 2.2.0
      script-module-routing # version 0.2.3
    ];
    meta = with lib; {
      description = "Kodi addon: Rocket Beans TV";
      longDescription = ''
        Rocket Beans TV is 24/7 Entertainment focusing on digital topics like gaming and digital popculture.
      '';
      homepage = "www.rocketbeans.tv";
      platform = platforms.all;
    };
  };
  metadata-tvshows-themoviedb-org-python = mkKodiPlugin {
    plugin = "metadata-tvshows-themoviedb-org-python";
    namespace = "metadata.tvshows.themoviedb.org.python";
    version = "1.4.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.tvshows.themoviedb.org.python/metadata.tvshows.themoviedb.org.python-1.4.0.zip";
      sha256 = "15n1yvfabjblaqqqbchh75d2bs256wm4qq17n5g4kw5v3gpp44l8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: TMDb TV Shows";
      longDescription = ''
        The Movie Database (TMDb) is a community built movie and TV database. Every piece of data has been added by our amazing community dating back to 2008. TMDb's strong international focus and breadth of data is largely unmatched and something we're incredibly proud of. Put simply, we live and breathe community and that's precisely what makes us different.
      '';
      homepage = "https://www.themoviedb.org";
      platform = platforms.all;
    };
  };
  plugin-video-zdf_de_lite = mkKodiPlugin {
    plugin = "plugin-video-zdf_de_lite";
    namespace = "plugin.video.zdf_de_lite";
    version = "5.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.zdf_de_lite/plugin.video.zdf_de_lite-5.0.2.zip";
      sha256 = "0l5mgs71zm57h0n9f362xmwz6mjlknafcszxsyhi4j2d0pp7xpz2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libzdf # version 5.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: ZDF Mediathek";
      longDescription = ''
        Watch videos on demand from the ZDF Mediathek.
      '';
      homepage = "https://www.zdf.de/";
      platform = platforms.all;
    };
  };
  script-playrandomvideos = mkKodiPlugin {
    plugin = "script-playrandomvideos";
    namespace = "script.playrandomvideos";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.playrandomvideos/script.playrandomvideos-2.0.0.zip";
      sha256 = "19jz1yb4j3xq329lchkaq1f9mvmb8z6ipd641x0v83vma4w49rrl";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Play Random Videos";
      longDescription = ''
        This add-on can quickly play random episodes from TV shows, movies from genres/sets/years/tags, and videos from playlists, the filesystem, and just about anything else, other than plugins.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-3satmediathek = mkKodiPlugin {
    plugin = "plugin-video-3satmediathek";
    namespace = "plugin.video.3satmediathek";
    version = "5.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.3satmediathek/plugin.video.3satmediathek-5.0.2.zip";
      sha256 = "178ay64y2l5m5x01lrjrl7chgs1qbmql2w29ap74pi936ln0bkdd";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libzdf # version 5.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: 3sat Mediathek";
      longDescription = ''
        This add-on provides access to the 3sat Mediathek. Videos may be geolocked to Germany.
      '';
      homepage = "https://www.3sat.de/";
      platform = platforms.all;
    };
  };
  metadata-tvshows-themoviedb-org = mkKodiPlugin {
    plugin = "metadata-tvshows-themoviedb-org";
    namespace = "metadata.tvshows.themoviedb.org";
    version = "3.5.13";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.tvshows.themoviedb.org/metadata.tvshows.themoviedb.org-3.5.13.zip";
      sha256 = "04jk3v7wsnzbvcny5xk0rlxjimbgpi5z9vfpjwcdzbv3jjs5jvwl";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-imdb-com # version 2.9.2
    ];
    meta = with lib; {
      description = "Kodi addon: The Movie Database";
      longDescription = ''
        themoviedb.org is a free and open movie database. It's completely user driven by people like you. TMDb is currently used by millions of people every month and with their powerful API, it is also used by many popular media centers like Kodi to retrieve Movie Metadata, Posters and Fanart to enrich the user's experience.
      '';
      homepage = "https://www.themoviedb.org/";
      platform = platforms.all;
    };
  };
  script-module-libzdf = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-libzdf";
    namespace = "script.module.libzdf";
    version = "5.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.libzdf/script.module.libzdf-5.0.2.zip";
      sha256 = "1a6xc8jz2xwzz771xmxdswqr24ryjz57nmk3rl4yfvm80j2zhgq1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: libzdf";
      longDescription = ''
        This is a scraper for the ZDF Mediathek (http://www.zdf.de) and similar.
      '';
      platform = platforms.all;
    };
  });
  script-tvmaze-integration = mkKodiPlugin {
    plugin = "script-tvmaze-integration";
    namespace = "script.tvmaze.integration";
    version = "0.7.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.tvmaze.integration/script.tvmaze.integration-0.7.0+matrix.1.zip";
      sha256 = "1b2aq4ikjskvykq00pycx8qk5cwrj2jaj1m3h04kdic5klgwqzdv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-kodi-six # version 0.1.3.1
    ];
    meta = with lib; {
      description = "Kodi addon: TV Maze Integration";
      longDescription = ''
        This integration allows you to mark shows as acquired on TV Maze (and add them to your followed shows if needed) when you add them to your library and mark them as watched on TV Maze after you watch them.  You can also manually follow, unfollow, tag, and untag shows.
      '';
      platform = platforms.all;
    };
  };
  service-xbmc-versioncheck = mkKodiPlugin {
    plugin = "service-xbmc-versioncheck";
    namespace = "service.xbmc.versioncheck";
    version = "0.5.14+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.xbmc.versioncheck/service.xbmc.versioncheck-0.5.14+matrix.1.zip";
      sha256 = "1s7v4mn2qx7p1im483iy138irhjh1mi6d6q2bnwhggp3kbpihx1h";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Version Check";
      longDescription = ''
        Kodi Version Check only supports a number of platforms/distros as releases may differ between them. For more information visit the kodi.tv website.
      '';
      homepage = "https://kodi.tv";
      platform = platforms.all;
    };
  };
  plugin-video-plutotv = mkKodiPlugin {
    plugin = "plugin-video-plutotv";
    namespace = "plugin.video.plutotv";
    version = "1.5.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.plutotv/plugin.video.plutotv-1.5.3.zip";
      sha256 = "1cnd000mj3h4h68vs75j37c68i1ff6lid2qr30xaq131gy8jhlkw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.7.0
      script-module-simplecache # version 1.0.0
      script-module-routing # version 0.2.3
      script-module-inputstreamhelper # version 0.3.3
    ];
    meta = with lib; {
      description = "Kodi addon: Pluto.TV";
      longDescription = ''
        Watch Free TV on Kodi! Stream Pluto TV's 100+ channels of news, sports, and the Internet's best, completely free on your Kodi device.
      '';
      homepage = "http://pluto.tv/";
      platform = platforms.all;
    };
  };
  plugin-video-sportschau = mkKodiPlugin {
    plugin = "plugin-video-sportschau";
    namespace = "plugin.video.sportschau";
    version = "6.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.sportschau/plugin.video.sportschau-6.0.0.zip";
      sha256 = "17zlf96yrczfmbq1qilddyk0ymfcff025mmvd43jah97v4nm1q91";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-libard # version 6.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: Sportschau";
      longDescription = ''
        This add-on fetches videos and livestreams from www.sportschau.de. Most of the streams are geolocked to Germany.
      '';
      homepage = "https://www.sportschau.de/";
      platform = platforms.all;
    };
  };
  plugin-video-wdrmediathek = mkKodiPlugin {
    plugin = "plugin-video-wdrmediathek";
    namespace = "plugin.video.wdrmediathek";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.wdrmediathek/plugin.video.wdrmediathek-2.0.1.zip";
      sha256 = "114gmbchxal0jgri9d14fcqgxp60xnllhbmfg0vl8fyf6is7fzc8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libwdr # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: WDR Mediathek";
      longDescription = ''
        This add-on lists the videos of the WDR Mediathek (www1.wdr.de/mediathek/video). Videos may be geolocked.
      '';
      homepage = "https://www1.wdr.de/mediathek/video/index.html";
      platform = platforms.all;
    };
  };
  plugin-video-locast = mkKodiPlugin {
    plugin = "plugin-video-locast";
    namespace = "plugin.video.locast";
    version = "1.1.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.locast/plugin.video.locast-1.1.3.zip";
      sha256 = "18f0xf1xqi7n908wz33bahh2b5qqb3imj9fp59wa9qx1hggjg2yh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.7.0
      script-module-simplecache # version 1.0.0
      script-module-routing # version 0.2.3
      script-module-inputstreamhelper # version 0.3.3
    ];
    meta = with lib; {
      description = "Kodi addon: Locast";
      longDescription = ''
        All you have to do is sign up online, provide your name and email address, and certify that you live in, and are logging on from, one of the select US cities (“Designated Market Area”). Then, you can select among local broadcasters and stream your favorite local station. Locast.org is a “digital translator,” meaning that Locast.org operates just like a traditional broadcast translator service, except instead of using an over-the-air signal to boost a broadcaster’s reach, we stream the signal over the Internet to consumers located within select US cities. Ever since the dawn of TV broadcasting in the mid-20th Century, non-profit organizations have provided “translator” TV stations as a public service. Where a primary broadcaster cannot reach a receiver with a strong enough signal, the translator amplifies that signal with another transmitter, allowing consumers who otherwise could not get the over-the-air signal to receive important programming, including local news, weather and of course, sports. Locast.org provides the same public service, except instead of an over-the-air signal transmitter, we provide the local broadcast signal via online streaming.
      '';
      homepage = "https://www.locast.org";
      platform = platforms.all;
    };
  };
  plugin-video-newson = mkKodiPlugin {
    plugin = "plugin-video-newson";
    namespace = "plugin.video.newson";
    version = "1.2.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.newson/plugin.video.newson-1.2.4.zip";
      sha256 = "07k7hs5mqlk1szk4bcajw4q3xzlq647svlm3g6c3ik50sx1kqara";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.7.0
      script-module-simplecache # version 1.0.0
      script-module-routing # version 0.2.3
    ];
    meta = with lib; {
      description = "Kodi addon: NewsON";
      longDescription = ''
        NewsON provides instant access to live or on-demand broadcasts from over 175 local stations in 114 U.S. markets. Access previous newscasts for up to 48 hours after they air, and share interesting stories with the integrated social media share function directly from the app. Search for a local station with the interactive map or watch the station closest to you on smartphones, tablets, or Roku streaming players. Save favorite stations, and stay updated with breaking news alerts sent directly to mobile devices from the local source of the news. Stay connected anytime, anywhere without a cable subscription or login.
      '';
      homepage = "http://watchnewson.com/";
      platform = platforms.all;
    };
  };
  script-module-tubed-api = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-tubed-api";
    namespace = "script.module.tubed.api";
    version = "1.0.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.tubed.api/script.module.tubed.api-1.0.4+matrix.1.zip";
      sha256 = "1kv3vdprwc5pxdjqzk5jmbqb8qvdjyipds0jzrg0hzvj0w73ha6g";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.12.4
    ];
    meta = with lib; {
      description = "Kodi addon: Tubed API";
      longDescription = ''
        The Tubed API module provides a convenient way to access YouTube's Data API in Kodi 19+
      '';
      platform = platforms.all;
    };
  });
  plugin-video-retrospect = mkKodiPlugin {
    plugin = "plugin-video-retrospect";
    namespace = "plugin.video.retrospect";
    version = "5.2.23+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.retrospect/plugin.video.retrospect-5.2.23+matrix.1.zip";
      sha256 = "0swwx1nbxvrlb2rk03fijwbghljv68320bh8k4mv4l57kbyz87r9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.18.0
      script-module-pytz # version 2014.2
      inputstream-adaptive # version 2.0.19
      script-module-inputstreamhelper # version 0.3.5
      script-module-pyscrypt # version 1.6.2
      script-module-pyaes # version 1.6.1
      resource-images-retrospect # version 1.0.8
    ];
    meta = with lib; {
      description = "Kodi addon: Retrospect";
      longDescription = ''
        Retrospect uses the official websites and freely available streams of different broadcasting companies (mainly Dutch, Belgian, British, Norwegian and Swedish) to make their re-run/catch-up episodes available on the Kodi platform.[CR][CR]More information can be found at https://rieter.net or the Retrospect wiki at https://github.com/retrospect-addon/plugin.video.retrospect/wiki/.
      '';
      platform = platforms.all;
    };
  };
  script-artistslideshow = mkKodiPlugin {
    plugin = "script-artistslideshow";
    namespace = "script.artistslideshow";
    version = "3.3.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.artistslideshow/script.artistslideshow-3.3.0+matrix.1.zip";
      sha256 = "1xiff79jnmkr0c86ji6nwagmgsxr15r344i48nsxzdc2h061f912";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-defusedxml # version 0.6.0+matrix.1
      script-module-kodi-six # version 0.1.3.1
      script-module-future # version 0.17.1+matrix.2
    ];
    meta = with lib; {
      description = "Kodi addon: Artist Slideshow";
      longDescription = ''
        Addon to download images and additional information from fanart.tv and theaudiodb.com of the currently playing artist. The images, along with local artists' images, and info can be used by the skin to create a slideshow for the artist being listened to.
      '';
      homepage = "https://kodi.wiki/index.php?title=Add-on:Artist_Slideshow";
      platform = platforms.all;
    };
  };
  context-item-extras = mkKodiPlugin {
    plugin = "context-item-extras";
    namespace = "context.item.extras";
    version = "1.4.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/context.item.extras/context.item.extras-1.4.2.zip";
      sha256 = "08js29c2xjfw64mhw4fs7i1krv1f019igiixvhjdx8z4gig2x6g7";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-routing # version 0.2.3+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Extras";
      longDescription = ''
        Provides an easy way to browse and view movie and TV show extras. Extras can be accessed from the context menu in the video library. By default, the add-on will look in the "Extras" sub-folder for content (can be changed in settings).

        Tip: for how to avoid extras beings scraped to library, see http://kodi.wiki/view/Add-on:Extras
      '';
      homepage = "http://kodi.wiki/view/Add-on:Extras";
      platform = platforms.all;
    };
  };
  script-radioparadise = mkKodiPlugin {
    plugin = "script-radioparadise";
    namespace = "script.radioparadise";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.radioparadise/script.radioparadise-1.0.0.zip";
      sha256 = "1a9914a653b1rgx03yj6alvxr8h95q0qq8mqm9xqdv1188nm130x";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Radio Paradise";
      longDescription = ''
        An eclectic DJ-mixed blend of rock, indie, electronica, world music, and more. Listener supported & always 100% commercial free.
      '';
      homepage = "https://radioparadise.com/";
      platform = platforms.all;
    };
  };
  plugin-video-tvvlaanderen = mkKodiPlugin {
    plugin = "plugin-video-tvvlaanderen";
    namespace = "plugin.video.tvvlaanderen";
    version = "1.0.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tvvlaanderen/plugin.video.tvvlaanderen-1.0.3+matrix.1.zip";
      sha256 = "1lyqfsl6ry7n7wy53cx6djq9ag4y64psynl3qhcr1vgdlwwi4w5d";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.6.0
      script-module-inputstreamhelper # version 0.5.1
      script-module-requests # version 2.22.0
      script-module-routing # version 0.2.0
      script-module-pyjwt # version 1.6.4
      inputstream-adaptive # version 2.4.3
    ];
    meta = with lib; {
      description = "Kodi addon: TV Vlaanderen";
      longDescription = ''
        This add-on gives access to the live tv channels and the video-on-demand content available in your TV Vlaanderen subscription.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-vtm-go = mkKodiPlugin {
    plugin = "plugin-video-vtm-go";
    namespace = "plugin.video.vtm.go";
    version = "1.2.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.vtm.go/plugin.video.vtm.go-1.2.3+matrix.1.zip";
      sha256 = "1nqs8mnbf9rl1hagizcyf7cb40fsw45hvvawr0jcry3ddrwjwxiv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.6.0
      script-module-requests # version 2.22.0
      script-module-routing # version 0.2.0
      script-module-pyjwt # version 1.6.4
      script-module-inputstreamhelper # version 0.3.4
      inputstream-adaptive # version 2.4.3
    ];
    meta = with lib; {
      description = "Kodi addon: VTM GO";
      longDescription = ''
        This add-on gives access to all live tv channels and all video-on-demand content available on the VTM GO platform.
      '';
      platform = platforms.all;
    };
  };
  service-iptv-manager = mkKodiPlugin {
    plugin = "service-iptv-manager";
    namespace = "service.iptv.manager";
    version = "0.2.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.iptv.manager/service.iptv.manager-0.2.3+matrix.1.zip";
      sha256 = "0mimqh0nmrxidp1d8w6n6dy5qgj6fc0asxvfn6mpi3xxiqnjj85c";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.6.0
      pvr-iptvsimple # version 3.8.8
    ];
    meta = with lib; {
      description = "Kodi addon: IPTV Manager";
      longDescription = ''
        IPTV Manager integrates IPTV channels from other add-ons in the Kodi TV and Radio menus.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-hbogoeu = mkKodiPlugin {
    plugin = "plugin-video-hbogoeu";
    namespace = "plugin.video.hbogoeu";
    version = "2.6.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.hbogoeu/plugin.video.hbogoeu-2.6.3+matrix.1.zip";
      sha256 = "0l0gbjmzbmhgg4v03z4a7hycpq5wwy0fmp5ik5l7jpv83077432f";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.0
      script-module-requests # version 2.12.4
      script-module-pyaes # version 1.6.1
      script-module-defusedxml # version 0.6.0
      script-module-dateutil # version 2.8.1
      script-module-inputstreamhelper # version 0.5.2
    ];
    meta = with lib; {
      description = "Kodi addon: hGO EU";
      longDescription = ''
        Simple, Kodi add-on to access HBO® Go EU content. (This add-on is not officially commissioned/supported by HBO®.)

        Important, HBO® Go must be paid for!!!  You need a valid account!
        Register on the official HBO® Go website for your region.

        Read the disclaimer!

        Curently support: Bosnia and Herzegovina, Bulgaria, Croatia, Czech Republic, Hungary, Macedonia, Montenegro, Polonia, Portugal, Romania, Serbia, Slovakia, Slovenija, Spain, Norway, Denmark, Sweden, Finland

        To report bugs or request assistence with the add-on go to: https://github.com/arvvoid/plugin.video.hbogoeu
      '';
      homepage = "https://arvvoid.github.io/plugin.video.hbogoeu";
      platform = platforms.all;
    };
  };
  script-tvmaze-scrobbler = mkKodiPlugin {
    plugin = "script-tvmaze-scrobbler";
    namespace = "script.tvmaze.scrobbler";
    version = "1.1.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.tvmaze.scrobbler/script.tvmaze.scrobbler-1.1.0+matrix.1.zip";
      sha256 = "0i9vplvmd130gh081ncz2ray44cgcmldpgmyc8djds4bdgwb4dsy";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version None
      script-module-pyxbmct # version None
      script-module-six # version None
      script-module-kodi-six # version None
      script-module-pyqrcode # version None
      script-module-dateutil # version None
    ];
    meta = with lib; {
      description = "Kodi addon: TVmaze Scrobbler/Tracker";
      longDescription = ''
        Automatically track all TV episodes you are watching to TVmaze. A must have if you want to sync your watch history between various applications.
        Sign up for a free account at https://tvmaze.com for more features.

        This Kodi TV episode Tracker uses the TVmaze.com user API's scrobbler endpoints(https://static.tvmaze.com/apidoc/)

        What this addon does:
        - Performs an initial sync between Kodi and TVmaze for the episodes you've watched.
        - If you add an episode to the Kodi library it marks it as "acquired" on TVmaze.
        - If you watch an episode in Kodi it marks it as "watched" in TVmaze.
        - If you mark an episode as watched in TVmaze it marks it as watched in Kodi.
      '';
      homepage = "https://www.tvmaze.com";
      platform = platforms.all;
    };
  };
  plugin-video-streamz = mkKodiPlugin {
    plugin = "plugin-video-streamz";
    namespace = "plugin.video.streamz";
    version = "1.0.5+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.streamz/plugin.video.streamz-1.0.5+matrix.1.zip";
      sha256 = "04628spsz7s07961smpx0kl3nr5nhrra0gv1ixjjdgb7npj7yiqs";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.6.0
      script-module-requests # version 2.22.0
      script-module-routing # version 0.2.0
      script-module-pyjwt # version 1.6.4
      script-module-inputstreamhelper # version 0.3.4
      inputstream-adaptive # version 2.4.3
    ];
    meta = with lib; {
      description = "Kodi addon: Streamz";
      longDescription = ''
        Streamz is a video-on-demand platform offering Flemish content from DPG Media, Telenet and VRT, but also including 'Home of HBO' content and blockbuster movies.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-tubed = mkKodiPlugin {
    plugin = "plugin-video-tubed";
    namespace = "plugin.video.tubed";
    version = "1.0.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tubed/plugin.video.tubed-1.0.3+matrix.1.zip";
      sha256 = "106ma2c5cq916d498zykk4382257rq72ifiq9i7x9m8z2zhsnn0v";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      inputstream-adaptive # version None
      script-module-arrow # version 0.15.5+matrix.1
      script-module-requests # version 2.22.0+matrix.1
      script-module-pyxbmct # version 1.3.1+matrix.1
      script-module-tubed-api # version 1.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: Tubed";
      longDescription = ''
        Browse your favorite content from YouTube; create, delete, and rename playlists; subscribe or unsubscribe from your favorite channels; and rate your favorite videos.
      '';
      homepage = "https://panicked.xyz/tubed/";
      platform = platforms.all;
    };
  };
  plugin-whereareyou = mkKodiPlugin {
    plugin = "plugin-whereareyou";
    namespace = "plugin.whereareyou";
    version = "0.4.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.whereareyou/plugin.whereareyou-0.4.1+matrix.1.zip";
      sha256 = "07c66kn9346a64vnw1bpnf69avywg3jifmsnj3daqqrnjmz58j0i";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.22.0+matrix.1
      script-module-websocket # version 0.5.7+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Where Are You";
      longDescription = ''
        Where Are You is a plugin for Kodi that accepts a URL from a stream file and then displays a dialog box with the title and message from the stream file URL.  After the dialog is dismissed a black video plays for 2 seconds.  This is basically to do what the media stub file does (which is display a title and a message for a given file), but for streaming files because the media stub only works if you have an optical drive attached to the device running Kodi.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-vrt-nu = mkKodiPlugin {
    plugin = "plugin-video-vrt-nu";
    namespace = "plugin.video.vrt.nu";
    version = "2.4.5+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.vrt.nu/plugin.video.vrt.nu-2.4.5+matrix.1.zip";
      sha256 = "07g1b166gxssxaw7h0dj60i8ckhdnyb2lfs2azh96srykk7dzxy9";
    };
    propagatedBuildInputs = [
      resource-images-studios-white # version 0.0.22
      script-module-beautifulsoup4 # version 4.6.2
      script-module-dateutil # version 2.8.0
      script-module-inputstreamhelper # version 0.4.3
      script-module-routing # version 0.2.3
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: VRT NU";
      longDescription = ''
        VRT NU is the video-on-demand platform of the Flemish public broadcaster (VRT).

          - Track the programs you like
          - List all videos alphabetically by program, category, channel or feature
          - Watch live streams from Eén, Canvas, Ketnet, Ketnet Junior and Sporza
          - Discover recently added or soon offline content
          - Browse the online TV guides or search VRT NU

        [I]The VRT NU add-on is not endorsed by VRT, and is provided 'as is' without any warranty of any kind.[/I]
      '';
      homepage = "https://github.com/add-ons/plugin.video.vrt.nu/wiki";
      platform = platforms.all;
    };
  };
  resource-language-zh_tw = mkKodiPlugin {
    plugin = "resource-language-zh_tw";
    namespace = "resource.language.zh_tw";
    version = "9.0.30";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.zh_tw/resource.language.zh_tw-9.0.30.zip";
      sha256 = "0qmp6rcsppqrxw53ca14xi5j4d8w0ayj08dw7nj3h45rfb1l8vz5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Chinese (Traditional)";
      longDescription = ''
        Chinese (Traditional) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-et_ee = mkKodiPlugin {
    plugin = "resource-language-et_ee";
    namespace = "resource.language.et_ee";
    version = "9.0.19";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.et_ee/resource.language.et_ee-9.0.19.zip";
      sha256 = "00nwzjqw235qa9dk1hqgqv2ndf15wih7grs8q57yq8w137ph5mb2";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Estonian";
      longDescription = ''
        Estonian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-it_it = mkKodiPlugin {
    plugin = "resource-language-it_it";
    namespace = "resource.language.it_it";
    version = "9.0.25";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.it_it/resource.language.it_it-9.0.25.zip";
      sha256 = "0kjnl35y2mflkzijfs12g429jb68bwy7qq1g5f6bv065hqpy9cc0";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Italian";
      longDescription = ''
        Italian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ja_jp = mkKodiPlugin {
    plugin = "resource-language-ja_jp";
    namespace = "resource.language.ja_jp";
    version = "9.0.18";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ja_jp/resource.language.ja_jp-9.0.18.zip";
      sha256 = "195239pz9wl5m5dam84pm8jmidcvd8v9qfn85ikqimpik23yxl97";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Japanese";
      longDescription = ''
        Japanese version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  script-embuary-info = mkKodiPlugin {
    plugin = "script-embuary-info";
    namespace = "script.embuary.info";
    version = "2.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.embuary.info/script.embuary.info-2.0.7.zip";
      sha256 = "0wrs25d6jb0fb55r4r31y7zvr242mwjprciv084mmyqpr5vgmiiz";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.9.1
      script-module-arrow # version 0.10.0
      script-module-simplecache # version 2.0.2
      script-module-routing # version 0.2.0
    ];
    meta = with lib; {
      description = "Kodi addon: Embuary Info";
      longDescription = ''
        Helper script to provide The Movie DB informations for persons, shows and movies. Works best with a skin integration.
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-ampache = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "plugin-audio-ampache";
    namespace = "plugin.audio.ampache";
    version = "1.2.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.ampache/plugin.audio.ampache-1.2.1+matrix.1.zip";
      sha256 = "0wn6n0c1wsf9bsxqslascpbvf9b8r1sqb5z7f87spwbg40qq7k15";
    };
    propagatedBuildInputs = [
      script-module-future # version 0.16.0
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Ampache";
      longDescription = ''
        A web based audio/video streaming application and file manager allowing you to access your music and videos from anywhere, using almost any internet enabled device.
      '';
      homepage = "http://ampache.org/";
      platform = platforms.all;
    };
  });
  plugin-video-nhlgcl = mkKodiPlugin {
    plugin = "plugin-video-nhlgcl";
    namespace = "plugin.video.nhlgcl";
    version = "2021.1.25+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.nhlgcl/plugin.video.nhlgcl-2021.1.25+matrix.1.zip";
      sha256 = "166zjxms20gkr21g0pcx3hf3zkhdqw7bzfj7fj2g64adb7lvb8rh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pytz # version None
      script-module-beautifulsoup4 # version None
      script-module-pil # version None
      script-module-requests # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: NHL TV™";
      longDescription = ''
        With NHL.TV you can access revolutionary 60fps (frames per second) video through Kodi
      '';
      homepage = "https://www.nhl.com/subscribe";
      platform = platforms.all;
    };
  };
  plugin-video-nasa = mkKodiPlugin {
    plugin = "plugin-video-nasa";
    namespace = "plugin.video.nasa";
    version = "3.0.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.nasa/plugin.video.nasa-3.0.1+matrix.1.zip";
      sha256 = "0ydx6qgnr5a5rfzib04hrf2spfzzi2s0xzjjc3i3dr569gml28c6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-xbmcswift2 # version 2.5.0
    ];
    meta = with lib; {
      description = "Kodi addon: Nasa";
      longDescription = ''
        This video plugin provides access to more than 1800 videos, 8 vodcasts and 4 nasa-tv livestreams[CR]All content is dynamic and should be always up to date.
      '';
      homepage = "https://www.nasa.gov/";
      platform = platforms.all;
    };
  };
  metadata-album-universal = mkKodiPlugin {
    plugin = "metadata-album-universal";
    namespace = "metadata.album.universal";
    version = "3.1.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.album.universal/metadata.album.universal-3.1.4.zip";
      sha256 = "0svacjghpdwjgkkincrv8w8drblaxj8jpbkckkqk4ajrx19jz6a7";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-allmusic-com # version 3.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-musicbrainz-org # version 2.1.2
      metadata-common-theaudiodb-com # version 1.8.1
    ];
    meta = with lib; {
      description = "Kodi addon: Universal Album Scraper";
      longDescription = ''
        This scraper collects information from the following supported sites: MusicBrainz, last.fm, allmusic.com and amazon.de, while grabs artwork from: fanart.tv, last.fm and allmusic.com. It can be set field by field that from which site you want that specific information.

        The initial search is always done on MusicBrainz. In case allmusic and/or amazon.de links are not added on the MusicBrainz site, fields from allmusic.com and/or amazon.de cannot be fetched (very easy to add those missing links though).
      '';
      platform = platforms.all;
    };
  };
  script-module-dropbox_auth = mkKodiPlugin {
    plugin = "script-module-dropbox_auth";
    namespace = "script.module.dropbox_auth";
    version = "8.4.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.dropbox_auth/script.module.dropbox_auth-8.4.4.zip";
      sha256 = "1q4scw91rkdkjxjp9kpkf96n0fiyry1qkx8cr7pipqj599rxd82c";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dropbox # version 9.4.0+matrix.1
      script-module-requests # version 2.22.0+matrix.1
      script-module-six # version 1.14.0+matrix.1
      script-module-qrcode # version 6.1.0+matrix.2
    ];
    meta = with lib; {
      description = "Kodi addon: Dropbox Authentification";
      longDescription = ''
        Provide Dropbox Authentification
      '';
      platform = platforms.all;
    };
  };
  resource-language-zh_cn = mkKodiPlugin {
    plugin = "resource-language-zh_cn";
    namespace = "resource.language.zh_cn";
    version = "9.0.23";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.zh_cn/resource.language.zh_cn-9.0.23.zip";
      sha256 = "1hwy7rfjjvdg9p8535svsgvyzdx321shh296fzg06vi4w50s085s";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Chinese (Simple)";
      longDescription = ''
        Chinese (Simple) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  skin-rapier = mkKodiPlugin {
    plugin = "skin-rapier";
    namespace = "skin.rapier";
    version = "12.2.26";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.rapier/skin.rapier-12.2.26.zip";
      sha256 = "02qrj69arwigv3c346az921fgcld5ny6lbhjqqkvzp6876vgbdf4";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
      script-favourites # version 4.0.9
      script-embuary-helper # version 2.0.2
      resource-images-studios-white # version 0.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: Rapier";
      longDescription = ''
        The goal is to provide a simple to use but clean and elegant interface that focuses on efficiency when browsing your media. Important considerations are put on usability, performance, and providing the user with flexibility when it comes to customization. Rapier tries to support all the latest features Kodi has to offer as long as it fits in with the skin's design goals.
      '';
      homepage = "https://kodi.wiki/view/Add-on:Rapier";
      platform = platforms.all;
    };
  };
  plugin-video-twitch = mkKodiPlugin {
    plugin = "plugin-video-twitch";
    namespace = "plugin.video.twitch";
    version = "2.5.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.twitch/plugin.video.twitch-2.5.4+matrix.1.zip";
      sha256 = "054gm0vsvzhnfwvxzlmfm636d06crwxmly0g4qx76824b0vgfs9i";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.11.0
      script-module-python-twitch # version 2.0.16
      script-module-requests # version 2.9.1
    ];
    meta = with lib; {
      description = "Kodi addon: Twitch";
      longDescription = ''
        Watch your favorite gaming streams!
      '';
      platform = platforms.all;
    };
  };
  script-module-python-twitch = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-python-twitch";
    namespace = "script.module.python.twitch";
    version = "2.0.16+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.python.twitch/script.module.python.twitch-2.0.16+matrix.1.zip";
      sha256 = "03bm1r4damlis92c1hf0nc9iinvxpwbg07192lllmldwkdbqhg0w";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.11.0
      script-module-requests # version 2.12.4
    ];
    meta = with lib; {
      description = "Kodi addon: python-twitch for Kodi";
      longDescription = ''
        python-twitch for Kodi is module for interaction with the Twitch.tv API based on python-twitch by ingwinlu.
      '';
      platform = platforms.all;
    };
  });
  resource-language-hu_hu = mkKodiPlugin {
    plugin = "resource-language-hu_hu";
    namespace = "resource.language.hu_hu";
    version = "9.0.26";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.hu_hu/resource.language.hu_hu-9.0.26.zip";
      sha256 = "14vmfxg2416r35j7bm4adk64xpqi0k4nscp43l338ig1xp36q3pw";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Hungarian";
      longDescription = ''
        Hungarian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-lv_lv = mkKodiPlugin {
    plugin = "resource-language-lv_lv";
    namespace = "resource.language.lv_lv";
    version = "9.0.16";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.lv_lv/resource.language.lv_lv-9.0.16.zip";
      sha256 = "1yn8yhx143x26k4bzm9b4azkcr0wmm2p31qs26fyxy79zxhxivyj";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Latvian";
      longDescription = ''
        Latvian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ro_ro = mkKodiPlugin {
    plugin = "resource-language-ro_ro";
    namespace = "resource.language.ro_ro";
    version = "9.0.17";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ro_ro/resource.language.ro_ro-9.0.17.zip";
      sha256 = "1hadvgfyqzbg09ahfz1ga3q3f21hfxcn95wa966dxs70c1g9dmvk";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Romanian";
      longDescription = ''
        Romanian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  script-sublissimo = mkKodiPlugin {
    plugin = "script-sublissimo";
    namespace = "script.sublissimo";
    version = "1.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.sublissimo/script.sublissimo-1.0.6.zip";
      sha256 = "1zx9j7bz77z17ybx3bdjd9s0bwjx2444m4ani3b6gnfzyqg8dsxa";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Sublissimo";
      longDescription = ''
        With this script you can edit specific lines, move or stretch subtitles, and synchronize with other subtitles. You can also synchronize with a videofile.
      '';
      platform = platforms.all;
    };
  };
  screensaver-digitalclock = mkKodiPlugin {
    plugin = "screensaver-digitalclock";
    namespace = "screensaver.digitalclock";
    version = "6.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.digitalclock/screensaver.digitalclock-6.0.1.zip";
      sha256 = "0d4x2w5mbb8yqyqsgqy8sghhdvsjyr6d3mfaak1b1mha91b5xg2a";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-skin-helper-colorpicker # version 1.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Digital Clock Screensaver";
      longDescription = ''
        Digital clock screensaver with date, now playing information, weather information, image slideshow and several options.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-redbull-tv = mkKodiPlugin {
    plugin = "plugin-video-redbull-tv";
    namespace = "plugin.video.redbull.tv";
    version = "3.2.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.redbull.tv/plugin.video.redbull.tv-3.2.2+matrix.1.zip";
      sha256 = "1mrpcb27nksc0absvgm6w8n656235r0j8mwylsg2173cvhk068w5";
    };
    propagatedBuildInputs = [
      script-module-dateutil # version 2.8.0
      script-module-routing # version 0.2.0
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Red Bull TV";
      longDescription = ''
        Red Bull TV gives you front-row access to live events, the best inaction sports, new music and entertainment, and thrilling videos from world adventurers.
      '';
      homepage = "http://www.redbull.tv/";
      platform = platforms.all;
    };
  };
  resource-language-af_za = mkKodiPlugin {
    plugin = "resource-language-af_za";
    namespace = "resource.language.af_za";
    version = "9.0.13";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.af_za/resource.language.af_za-9.0.13.zip";
      sha256 = "0lgxxlxj6cgnv5ms563473q6x2ryqcsbkgk975424lys8qxg6w7g";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Afrikaans";
      longDescription = ''
        Afrikaans version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-en_us = mkKodiPlugin {
    plugin = "resource-language-en_us";
    namespace = "resource.language.en_us";
    version = "9.0.20";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.en_us/resource.language.en_us-9.0.20.zip";
      sha256 = "1cg4hrszam3sykdh1b972n6rnf4vsp0qqz1s4241q76951ylc5g2";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: English (US)";
      longDescription = ''
        English (US) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-eu_es = mkKodiPlugin {
    plugin = "resource-language-eu_es";
    namespace = "resource.language.eu_es";
    version = "9.0.16";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.eu_es/resource.language.eu_es-9.0.16.zip";
      sha256 = "0ppl3ajynll755z7npmnl0a8n4677vgjz87gn3v9wmrjpz4ilvvp";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Basque";
      longDescription = ''
        Basque version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  skin-amber = mkKodiPlugin {
    plugin = "skin-amber";
    namespace = "skin.amber";
    version = "3.4.11";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.amber/skin.amber-3.4.11.zip";
      sha256 = "0wacxnabd4arq1zbx10dsjar0fyczlhnf0slwh3ykn31770h52vb";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
      script-favourites # version 7.1.1
      resource-uisounds-amber # version 1.0.0
      script-skinshortcuts # version 1.0.17
    ];
    meta = with lib; {
      description = "Kodi addon: Amber";
      longDescription = ''
        No bloatware, just your media with an easy to navigate interface.[CR]Uses some textures from Mediastream and Aeon skins.
      '';
      platform = platforms.all;
    };
  };
  service-master-lock = mkKodiPlugin {
    plugin = "service-master-lock";
    namespace = "service.master.lock";
    version = "1.0.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.master.lock/service.master.lock-1.0.1+matrix.1.zip";
      sha256 = "0c9qs1wbddgfsablfisyxg16dziqc45v948b8gs7bzgrck3rf6nn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Master Lock Service";
      longDescription = ''
        Master Lock Service checks if Kodi has a Master Lock configured and if it is unlocked. If that is the case, it will enage the Master Lock whenever the screen saver starts.
      '';
      platform = platforms.all;
    };
  };
  script-xbmc-boblight = mkKodiPlugin {
    plugin = "script-xbmc-boblight";
    namespace = "script.xbmc.boblight";
    version = "2.0.19";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.xbmc.boblight/script.xbmc.boblight-2.0.19.zip";
      sha256 = "0kpfzzigisjj84xl79ddjb9j5z2glvh6sgrgk9fkz50bl4kqrybm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Kodi Boblight";
      longDescription = ''
        Connect Kodi output to boblight backend.
      '';
      homepage = "https://code.google.com/archive/p/boblight";
      platform = platforms.all;
    };
  };
  skin-unity = mkKodiPlugin {
    plugin = "skin-unity";
    namespace = "skin.unity";
    version = "0.19.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.unity/skin.unity-0.19.0.zip";
      sha256 = "02qgwq6b7cbspjds6v72p2ndp3rqy1d1b0g08ckiibkk5mbzihg1";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
      script-skinshortcuts # version 1.1.4
    ];
    meta = with lib; {
      description = "Kodi addon: Unity";
      longDescription = ''
        Unity is an adaptation of Confluence based on a material design.
      '';
      platform = platforms.all;
    };
  };
  resource-language-sr_rs = mkKodiPlugin {
    plugin = "resource-language-sr_rs";
    namespace = "resource.language.sr_rs";
    version = "9.0.14";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.sr_rs/resource.language.sr_rs-9.0.14.zip";
      sha256 = "1jll4zijcl7kclikk2jjpbv862c3bba7mihqfgx3i3diq08c7b0x";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Serbian (Cyrillic)";
      longDescription = ''
        Serbian (Cyrillic) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-gl_es = mkKodiPlugin {
    plugin = "resource-language-gl_es";
    namespace = "resource.language.gl_es";
    version = "9.0.17";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.gl_es/resource.language.gl_es-9.0.17.zip";
      sha256 = "1qmhwn2l498ms48zxbkw9wm4mgd9ng0d4b6vskv8kl6k381djqhr";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Galician";
      longDescription = ''
        Galician version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-nl_nl = mkKodiPlugin {
    plugin = "resource-language-nl_nl";
    namespace = "resource.language.nl_nl";
    version = "9.0.27";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.nl_nl/resource.language.nl_nl-9.0.27.zip";
      sha256 = "187awa8zfj54bzmwhb6xx788qh6n34yjx8k1pl7cxbshg1018k7q";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Dutch";
      longDescription = ''
        Dutch version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-es_es = mkKodiPlugin {
    plugin = "resource-language-es_es";
    namespace = "resource.language.es_es";
    version = "9.0.30";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.es_es/resource.language.es_es-9.0.30.zip";
      sha256 = "165k1bm33jcrrhlz1wbdky3y3gk991q271pv902fa7gr335bszi0";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Spanish";
      longDescription = ''
        Spanish version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  metadata-common-themoviedb-org = mkKodiPlugin {
    plugin = "metadata-common-themoviedb-org";
    namespace = "metadata.common.themoviedb.org";
    version = "3.2.13";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.themoviedb.org/metadata.common.themoviedb.org-3.2.13.zip";
      sha256 = "02r1lxqan9zxk6a0hhp4aswc9davw8arl7dl7jvj9yxn8iav7nnd";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: The Movie Database Scraper Library";
      longDescription = ''
        Download thumbs and fanarts from www.themoviedb.org
      '';
      platform = platforms.all;
    };
  };
  script-module-beautifulsoup4 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-beautifulsoup4";
    namespace = "script.module.beautifulsoup4";
    version = "4.9.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.beautifulsoup4/script.module.beautifulsoup4-4.9.3+matrix.1.zip";
      sha256 = "11zr245sqmlq9jpxhbw78rda8mn8p9012fdhnilzgdb2za3zk42j";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-soupsieve # version 2.0.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: BeautifulSoup4";
      longDescription = ''
        Beautiful Soup is a library that makes it easy to scrape information from web pages. It sits atop an HTML or XML parser, providing Pythonic idioms for iterating, searching, and modifying the parse tree.
      '';
      homepage = "https://www.crummy.com/software/BeautifulSoup/";
      platform = platforms.all;
    };
  });
  script-module-soupsieve = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-soupsieve";
    namespace = "script.module.soupsieve";
    version = "2.1.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.soupsieve/script.module.soupsieve-2.1.0+matrix.1.zip";
      sha256 = "1x8w42glxslam2yx44wv0i91y324lqa528igyqk2lxmn7xskh1va";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Soup Sieve";
      longDescription = ''
        Soup Sieve is a CSS selector library designed to be used with Beautiful Soup 4. It aims to provide selecting, matching, and filtering using modern CSS selectors.
      '';
      homepage = "https://pypi.org/project/soupsieve/";
      platform = platforms.all;
    };
  });
  plugin-video-svtplay = mkKodiPlugin {
    plugin = "plugin-video-svtplay";
    namespace = "plugin.video.svtplay";
    version = "5.1.12+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.svtplay/plugin.video.svtplay-5.1.12+matrix.1.zip";
      sha256 = "031441fg2a7szjwix6sfq24rdlwnpcjkf62ij387rvhywzmhngjg";
    };
    propagatedBuildInputs = [
      script-module-requests # version 2.22.0
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: SVT Play";
      longDescription = ''
        With this addon you can stream content from SVT Play (svtplay.se).
      '';
      homepage = "https://www.svtplay.se";
      platform = platforms.all;
    };
  };
  metadata-themoviedb-org = mkKodiPlugin {
    plugin = "metadata-themoviedb-org";
    namespace = "metadata.themoviedb.org";
    version = "5.2.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.themoviedb.org/metadata.themoviedb.org-5.2.6.zip";
      sha256 = "0rbr4c6y7m3gimnfghjc4d6qj2shxv1lfdqb6xr9cingdfbizw2a";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-imdb-com # version 2.9.2
      metadata-common-themoviedb-org # version 3.2.6
    ];
    meta = with lib; {
      description = "Kodi addon: The Movie Database";
      longDescription = ''
        themoviedb.org is a free and open movie database. It's completely user driven by people like you. TMDb is currently used by millions of people every month and with their powerful API, it is also used by many popular media centers like Kodi to retrieve Movie Metadata, Posters and Fanart to enrich the user's experience.
      '';
      homepage = "https://www.themoviedb.org";
      platform = platforms.all;
    };
  };
  script-module-web-pdb = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-web-pdb";
    namespace = "script.module.web-pdb";
    version = "1.5.6+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.web-pdb/script.module.web-pdb-1.5.6+matrix.1.zip";
      sha256 = "1gm20vxx3s3p28kqnrgz0n373a43yfs8s8vr25fb75g7cmz8yp90";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-bottle # version 0.12.0
    ];
    meta = with lib; {
      description = "Kodi addon: Web-PDB";
      longDescription = ''
        Provides a web-UI for Python's built-in PDB debugger for remote debugging Kodi addons.
      '';
      platform = platforms.all;
    };
  });
  plugin-video-newyankeeworkshop = mkKodiPlugin {
    plugin = "plugin-video-newyankeeworkshop";
    namespace = "plugin.video.newyankeeworkshop";
    version = "0.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.newyankeeworkshop/plugin.video.newyankeeworkshop-0.0.4.zip";
      sha256 = "0wxpf8zn5lw3694lhc3il7yh3ggamjc9pkvb8ah0v1xmxdbiil5c";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
      script-module-beautifulsoup4 # version 4.6.2
    ];
    meta = with lib; {
      description = "Kodi addon: The New Yankee Workshop";
      longDescription = ''
        Hosted by master carpenter Norm Abram, who is legendary for his woodworking skills, The New Yankee Workshop has guided millions of viewers through the hands-on process of furniture making.
      '';
      homepage = "https://www.newyankee.com/";
      platform = platforms.all;
    };
  };
  metadata-universal = mkKodiPlugin {
    plugin = "metadata-universal";
    namespace = "metadata.universal";
    version = "5.4.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.universal/metadata.universal-5.4.6.zip";
      sha256 = "1wsjxlcgisrwqd6cbi8s2d2lxaa8a5a17gcpilrwrmzh8rzs0q74";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-imdb-com # version 2.9.2
      metadata-common-ofdb-de # version 1.0.3
      metadata-common-themoviedb-org # version 3.2.0
      metadata-common-omdbapi-com # version 1.1.1
    ];
    meta = with lib; {
      description = "Kodi addon: Universal Movie Scraper";
      longDescription = ''
        Universal Scraper is currently the most customizable scraper by collecting information from the following supported sites: IMDb, themoviedb.org, Rotten Tomatoes, OFDb.de, fanart.tv, port.hu. This scraper is currently the flagship of the Team-Kodi scrapers. The initial search can be done either on TMDb or IMDb (according to the settings), but following that it can be set field by field that from which site you want that specific information.
      '';
      platform = platforms.all;
    };
  };
  resource-language-sl_si = mkKodiPlugin {
    plugin = "resource-language-sl_si";
    namespace = "resource.language.sl_si";
    version = "9.0.13";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.sl_si/resource.language.sl_si-9.0.13.zip";
      sha256 = "0vjbh2ks6nwqra6g3jffa9gcsd9l8fbc22xs7j0a51082hyixhds";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Slovenian";
      longDescription = ''
        Slovenian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-pl_pl = mkKodiPlugin {
    plugin = "resource-language-pl_pl";
    namespace = "resource.language.pl_pl";
    version = "9.0.20";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.pl_pl/resource.language.pl_pl-9.0.20.zip";
      sha256 = "1mrfvw85d9zri1b4hjrvi530f8n72q00ij9x12yvm5r50lbxfas4";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Polish";
      longDescription = ''
        Polish version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-el_gr = mkKodiPlugin {
    plugin = "resource-language-el_gr";
    namespace = "resource.language.el_gr";
    version = "9.0.20";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.el_gr/resource.language.el_gr-9.0.20.zip";
      sha256 = "0hdg7zbpfcwckdn1ddk1mdmjpiaddimb5w89qyy71cka4l0gg0s6";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Greek";
      longDescription = ''
        Greek version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-is_is = mkKodiPlugin {
    plugin = "resource-language-is_is";
    namespace = "resource.language.is_is";
    version = "9.0.18";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.is_is/resource.language.is_is-9.0.18.zip";
      sha256 = "12j1j5rkhq7bqs2g45jnwbncf8vwqhvwvykh86xhaxn9036lcpfs";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Icelandic";
      longDescription = ''
        Icelandic version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-travel = mkKodiPlugin {
    plugin = "plugin-video-travel";
    namespace = "plugin.video.travel";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.travel/plugin.video.travel-4.0.1.zip";
      sha256 = "1s1dh5d6frmqhkv43xzlj99b3r1bsjiz8g9swzxs3a0d0qrx72fy";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Travel Channel";
      longDescription = ''
        Check out travel videos, shows, and guides on top travel destinations on Travel Channel
      '';
      homepage = "www.travelchannel.com/";
      platform = platforms.all;
    };
  };
  plugin-video-shoutfactorytv = mkKodiPlugin {
    plugin = "plugin-video-shoutfactorytv";
    namespace = "plugin.video.shoutfactorytv";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.shoutfactorytv/plugin.video.shoutfactorytv-4.0.1.zip";
      sha256 = "1hrc7jz562rix977a04v2d7czpz4xiwgr3z81wz40rhrpcv9zdv8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.2
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: Shout Factory TV";
      longDescription = ''
        SHOUT! FACTORY TV is a premiere digital entertainment streaming service that brings timeless and contemporary cult favorites to pop culture fans.
      '';
      homepage = "http://www.shoutfactorytv.com/";
      platform = platforms.all;
    };
  };
  plugin-video-longnow = mkKodiPlugin {
    plugin = "plugin-video-longnow";
    namespace = "plugin.video.longnow";
    version = "0.1.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.longnow/plugin.video.longnow-0.1.2.zip";
      sha256 = "0xfm7w468m6d1z0xbiajv35gzz93ypx24k3hzssrki3jpayhhs6n";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.8.2
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Long Now Seminars";
      longDescription = ''
        This program is an unofficial viewer for seminars of the Long Now Foundation in Kodi. You need to have an account at https://longnow.org to make use of that plugin.
      '';
      homepage = "http://www.galois.de/projects/kodi_longnow";
      platform = platforms.all;
    };
  };
  plugin-video-foodnetwork = mkKodiPlugin {
    plugin = "plugin-video-foodnetwork";
    namespace = "plugin.video.foodnetwork";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.foodnetwork/plugin.video.foodnetwork-4.0.1.zip";
      sha256 = "0s8f4fn3w2d020rbsj3sqb65rh7b4lrym30yp6fy1fspd8k0q4lz";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Food Network";
      longDescription = ''
        Play videos from the Food Network
      '';
      homepage = "www.foodnetwork.com";
      platform = platforms.all;
    };
  };
  plugin-video-hgtv = mkKodiPlugin {
    plugin = "plugin-video-hgtv";
    namespace = "plugin.video.hgtv";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.hgtv/plugin.video.hgtv-4.0.1.zip";
      sha256 = "1vm40n8dqjwzdxgwyrbh9cgvsyzxjzx8zbymal9iabdsdfvy5cr3";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: HGTV";
      longDescription = ''
        Play videos from the HGTV Network
      '';
      homepage = "www.hgtv.com";
      platform = platforms.all;
    };
  };
  plugin-video-diy = mkKodiPlugin {
    plugin = "plugin-video-diy";
    namespace = "plugin.video.diy";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.diy/plugin.video.diy-4.0.1.zip";
      sha256 = "1zijjhp3vwpgwm57yd0l46cv5rjynpq6mi3vm9s6b8kdiksgjsik";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: DIY Network";
      longDescription = ''
        From remodeling to gardening to crafts DIYNetwork.com provides resources and knowledge through step-by-step photos and videos
      '';
      homepage = "https://www.diynetwork.com/";
      platform = platforms.all;
    };
  };
  plugin-video-popcorntimes = mkKodiPlugin {
    plugin = "plugin-video-popcorntimes";
    namespace = "plugin.video.popcorntimes";
    version = "2.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.popcorntimes/plugin.video.popcorntimes-2.0.zip";
      sha256 = "18dv28vpln1yzy26y6w8plnqa9zhfmwkgyd8vvxpslrz0sfhyg2q";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.12.4
      script-module-beautifulsoup4 # version 4.3.2
    ];
    meta = with lib; {
      description = "Kodi addon: Popcorntimes.tv";
      longDescription = ''
        Video plugin for popcorntimes.tv
      '';
      homepage = "https://popcorntimes.tv/";
      platform = platforms.all;
    };
  };
  plugin-audio-soundcloud = mkKodiPlugin {
    plugin = "plugin-audio-soundcloud";
    namespace = "plugin.audio.soundcloud";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.soundcloud/plugin.audio.soundcloud-4.0.0.zip";
      sha256 = "1rlpbgk9cb02qhsllvzvbgifr8dj0csvhqvahf3z0r6i6w2gh2rc";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: SoundCloud";
      longDescription = ''
        SoundCloud is a music and podcast streaming platform that lets you listen to millions of songs from around the world.
      '';
      homepage = "https://soundcloud.com";
      platform = platforms.all;
    };
  };
  script-xbmcbackup = mkKodiPlugin {
    plugin = "script-xbmcbackup";
    namespace = "script.xbmcbackup";
    version = "1.6.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.xbmcbackup/script.xbmcbackup-1.6.4.zip";
      sha256 = "1954zw2d6iggmxkk90h4c31gn6xmnj1gnmjsf6yi4v134yy7mnq8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.8.0
      script-module-future # version 0.18.2+matrix.1
      script-module-dropbox # version 9.4.0
    ];
    meta = with lib; {
      description = "Kodi addon: Backup";
      longDescription = ''
        Ever hosed your Kodi configuration and wished you'd had a backup? Now you can with one easy click. You can export your database, playlist, thumbnails, addons and other configuration details to any source writeable by Kodi or directly to Dropbox cloud storage. Backups can be run on demand or via a scheduler.
      '';
      platform = platforms.all;
    };
  };
  resource-language-uz_uz = mkKodiPlugin {
    plugin = "resource-language-uz_uz";
    namespace = "resource.language.uz_uz";
    version = "9.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.uz_uz/resource.language.uz_uz-9.0.5.zip";
      sha256 = "184ypx5rpmj6pb6h03glgqfwmbky3fj0zi8n24g040ch8dzhrpdp";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Uzbek";
      longDescription = ''
        Uzbek version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-th_th = mkKodiPlugin {
    plugin = "resource-language-th_th";
    namespace = "resource.language.th_th";
    version = "9.0.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.th_th/resource.language.th_th-9.0.10.zip";
      sha256 = "1z59w9q2135d32ndg2vj4bpwlvxqfsgc41mzypsdy988knj3z2cx";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Thai";
      longDescription = ''
        Thai version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-uk_ua = mkKodiPlugin {
    plugin = "resource-language-uk_ua";
    namespace = "resource.language.uk_ua";
    version = "9.0.14";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.uk_ua/resource.language.uk_ua-9.0.14.zip";
      sha256 = "02cq4i27b4lkfkww237j8r5nl2jm2v0vfbk4wd6fj0caq4srwpnh";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Ukrainian";
      longDescription = ''
        Ukrainian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-szl = mkKodiPlugin {
    plugin = "resource-language-szl";
    namespace = "resource.language.szl";
    version = "9.0.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.szl/resource.language.szl-9.0.10.zip";
      sha256 = "0b7mwi8q5fyba8bcp3m8hs18gnyzk30wqas110gpcxcyp1f12hac";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Silesian";
      longDescription = ''
        Silesian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ta_in = mkKodiPlugin {
    plugin = "resource-language-ta_in";
    namespace = "resource.language.ta_in";
    version = "9.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ta_in/resource.language.ta_in-9.0.9.zip";
      sha256 = "1w85qiaamnb9f8a832i761g4q4729yrk5ys0gfkv1yb26liasra9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Tamil (India)";
      longDescription = ''
        Tamil (India) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-tg_tj = mkKodiPlugin {
    plugin = "resource-language-tg_tj";
    namespace = "resource.language.tg_tj";
    version = "9.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.tg_tj/resource.language.tg_tj-9.0.7.zip";
      sha256 = "0w4dfmbppwprld89bxwz8h6008501hlgdf8d9xapl3nbnnjzsiyc";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Tajik";
      longDescription = ''
        Tajik version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-sr_rs_at_latin = mkKodiPlugin {
    plugin = "resource-language-sr_rs_at_latin";
    namespace = "resource.language.sr_rs@latin";
    version = "9.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.sr_rs@latin/resource.language.sr_rs@latin-9.0.9.zip";
      sha256 = "";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Serbian";
      longDescription = ''
        Serbian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-sq_al = mkKodiPlugin {
    plugin = "resource-language-sq_al";
    namespace = "resource.language.sq_al";
    version = "9.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.sq_al/resource.language.sq_al-9.0.8.zip";
      sha256 = "0sfzk0qmvm82idaws5wn33xpdl7x3h266n86s8j51b1ibs0x5n4k";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Albanian";
      longDescription = ''
        Albanian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-si_lk = mkKodiPlugin {
    plugin = "resource-language-si_lk";
    namespace = "resource.language.si_lk";
    version = "9.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.si_lk/resource.language.si_lk-9.0.5.zip";
      sha256 = "0ljk70pqwq16xzqxmd7lzhf0s49xfnd436akc05q88b86bmf69z2";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Sinhala";
      longDescription = ''
        Sinhala version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-mt_mt = mkKodiPlugin {
    plugin = "resource-language-mt_mt";
    namespace = "resource.language.mt_mt";
    version = "9.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.mt_mt/resource.language.mt_mt-9.0.8.zip";
      sha256 = "106z28lmc1n5d5jx052y02f7ndy2dwr4ggz15i12swmbz0gfwkm5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Maltese";
      longDescription = ''
        Maltese version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-my_mm = mkKodiPlugin {
    plugin = "resource-language-my_mm";
    namespace = "resource.language.my_mm";
    version = "9.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.my_mm/resource.language.my_mm-9.0.7.zip";
      sha256 = "0aaw9dr9jjylm9z60vba1npwx2gail5sjki5fcxli6wl00b6w78x";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Burmese";
      longDescription = ''
        Burmese version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-nb_no = mkKodiPlugin {
    plugin = "resource-language-nb_no";
    namespace = "resource.language.nb_no";
    version = "9.0.15";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.nb_no/resource.language.nb_no-9.0.15.zip";
      sha256 = "16878rrl3p0z5q3f7hfyxxk6njkhjl0clhjgx4v6vfipfbr3wp9f";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Norwegian";
      longDescription = ''
        Norwegian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-mi = mkKodiPlugin {
    plugin = "resource-language-mi";
    namespace = "resource.language.mi";
    version = "9.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.mi/resource.language.mi-9.0.7.zip";
      sha256 = "0q82mhjmw2yrszj2zqmsc7km4xyrhbn2b072pnwinjx0czqa5dk3";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Maori";
      longDescription = ''
        Maori version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-mk_mk = mkKodiPlugin {
    plugin = "resource-language-mk_mk";
    namespace = "resource.language.mk_mk";
    version = "9.0.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.mk_mk/resource.language.mk_mk-9.0.10.zip";
      sha256 = "1af2r12c2yjjvbmlz0f6symd9p2pjmxnfw1rpckp1d86s88hj5jb";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Macedonian";
      longDescription = ''
        Macedonian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-mn_mn = mkKodiPlugin {
    plugin = "resource-language-mn_mn";
    namespace = "resource.language.mn_mn";
    version = "9.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.mn_mn/resource.language.mn_mn-9.0.5.zip";
      sha256 = "1r133ijfyf5gh9f810mz03lh7g775nlvbzqjgzycv2bb30z898r8";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Mongolian (Mongolia)";
      longDescription = ''
        Mongolian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ms_my = mkKodiPlugin {
    plugin = "resource-language-ms_my";
    namespace = "resource.language.ms_my";
    version = "9.0.15";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ms_my/resource.language.ms_my-9.0.15.zip";
      sha256 = "1a39pq2vvvzkqmx911ck5r0pa8hk7yddc5p6vq189gk0i25kd1pg";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Malay";
      longDescription = ''
        Malay version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-hr_hr = mkKodiPlugin {
    plugin = "resource-language-hr_hr";
    namespace = "resource.language.hr_hr";
    version = "9.0.18";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.hr_hr/resource.language.hr_hr-9.0.18.zip";
      sha256 = "0vj6vf6j0zqvvqfp1rx9hddrz7x9mlw93xsmm2lav1hgzx1yql05";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Croatian";
      longDescription = ''
        Croatian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-hy_am = mkKodiPlugin {
    plugin = "resource-language-hy_am";
    namespace = "resource.language.hy_am";
    version = "9.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.hy_am/resource.language.hy_am-9.0.5.zip";
      sha256 = "1qdvmyv1a437p246i2dgji1la5kwb4086i02lhdxvh9gsrif4bng";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Armenian";
      longDescription = ''
        Armenian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-id_id = mkKodiPlugin {
    plugin = "resource-language-id_id";
    namespace = "resource.language.id_id";
    version = "9.0.12";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.id_id/resource.language.id_id-9.0.12.zip";
      sha256 = "1i3wr0yxgvcvrj4dsdpn1d45kdvv0hbwqqlhc7cnd8ysvv2cbqsb";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Indonesian";
      longDescription = ''
        Indonesian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-he_il = mkKodiPlugin {
    plugin = "resource-language-he_il";
    namespace = "resource.language.he_il";
    version = "9.0.15";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.he_il/resource.language.he_il-9.0.15.zip";
      sha256 = "0w3hv5gi9p8zn8b1hc78rvbxk6kym5ghhrjmap6iwk7kcxn746a5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Hebrew";
      longDescription = ''
        Hebrew version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-hi_in = mkKodiPlugin {
    plugin = "resource-language-hi_in";
    namespace = "resource.language.hi_in";
    version = "9.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.hi_in/resource.language.hi_in-9.0.4.zip";
      sha256 = "1kh8p1f7dbpqfzj931fm6y6dqaw85zqiz6308q2yzrrdhrgpk8ya";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Hindi (Devanagiri)";
      longDescription = ''
        Hindi version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-fo_fo = mkKodiPlugin {
    plugin = "resource-language-fo_fo";
    namespace = "resource.language.fo_fo";
    version = "9.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.fo_fo/resource.language.fo_fo-9.0.7.zip";
      sha256 = "11wb5cpafw4qnphphr5mmqgp0szf0j596yysp973hmki6l1bsf8n";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Faroese";
      longDescription = ''
        Faroese version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-fr_ca = mkKodiPlugin {
    plugin = "resource-language-fr_ca";
    namespace = "resource.language.fr_ca";
    version = "9.0.25";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.fr_ca/resource.language.fr_ca-9.0.25.zip";
      sha256 = "15kdvv3zg7bhg9727zmrygbnw901mmg1vaxv479iyrp0s0c13jp4";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: French (Canada)";
      longDescription = ''
        French (Canada) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-fa_af = mkKodiPlugin {
    plugin = "resource-language-fa_af";
    namespace = "resource.language.fa_af";
    version = "9.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.fa_af/resource.language.fa_af-9.0.6.zip";
      sha256 = "1r947m72m3wgsdm3rclqr44yad585mjf3ljf48na62fvh4fy9i7q";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Persian";
      longDescription = ''
        Persian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-fa_ir = mkKodiPlugin {
    plugin = "resource-language-fa_ir";
    namespace = "resource.language.fa_ir";
    version = "9.0.11";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.fa_ir/resource.language.fa_ir-9.0.11.zip";
      sha256 = "02pm739dlln7rrffsx0ag51mznxa9rfnr94kwj9qq2hin9pwyd45";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Persian (Iran)";
      longDescription = ''
        Persian (Iran) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-eo = mkKodiPlugin {
    plugin = "resource-language-eo";
    namespace = "resource.language.eo";
    version = "9.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.eo/resource.language.eo-9.0.6.zip";
      sha256 = "1si9v45fqf4lxgpz175k1xvycjmbwlwihb5gipb9vzlv2las4i97";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Esperanto";
      longDescription = ''
        Esperanto version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-es_ar = mkKodiPlugin {
    plugin = "resource-language-es_ar";
    namespace = "resource.language.es_ar";
    version = "9.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.es_ar/resource.language.es_ar-9.0.9.zip";
      sha256 = "0h26q4s306ddi8qw0ijqnw4y780n13s339d4aqwrvl5ssnr193pb";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Spanish (Argentina)";
      longDescription = ''
        Spanish (Argentina) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-en_nz = mkKodiPlugin {
    plugin = "resource-language-en_nz";
    namespace = "resource.language.en_nz";
    version = "9.0.11";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.en_nz/resource.language.en_nz-9.0.11.zip";
      sha256 = "164bs7wi1qwc5frwfzqjj23nlfn9f46rgzvz4jyvxbcrxy0gifpz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: English (New Zealand)";
      longDescription = ''
        English (New Zealand) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-en_au = mkKodiPlugin {
    plugin = "resource-language-en_au";
    namespace = "resource.language.en_au";
    version = "9.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.en_au/resource.language.en_au-9.0.8.zip";
      sha256 = "187dxh8bd8i8x8damsbddmykm0vxaljrb8jszcvs5azgc186dffy";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: English (Australia)";
      longDescription = ''
        English (Australia) version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-bs_ba = mkKodiPlugin {
    plugin = "resource-language-bs_ba";
    namespace = "resource.language.bs_ba";
    version = "9.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.bs_ba/resource.language.bs_ba-9.0.6.zip";
      sha256 = "1zjm06414rrjmsllghj56m2sm37m9zm6n3v7dbgd1cq6hdmb1chc";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Bosnian";
      longDescription = ''
        Bosnian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-da_dk = mkKodiPlugin {
    plugin = "resource-language-da_dk";
    namespace = "resource.language.da_dk";
    version = "9.0.28";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.da_dk/resource.language.da_dk-9.0.28.zip";
      sha256 = "0mhq2m006wxaa0q0q59i88dl856lxmw23hk1h7bsgcvp2jpsi88i";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Danish";
      longDescription = ''
        Danish version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-az_az = mkKodiPlugin {
    plugin = "resource-language-az_az";
    namespace = "resource.language.az_az";
    version = "9.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.az_az/resource.language.az_az-9.0.5.zip";
      sha256 = "1c77gsyxd947ga6x84ady61yxwsd21l91zp19ivy0ivmjlcj96yz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Azerbaijani";
      longDescription = ''
        Azerbaijani version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-be_by = mkKodiPlugin {
    plugin = "resource-language-be_by";
    namespace = "resource.language.be_by";
    version = "9.0.17";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.be_by/resource.language.be_by-9.0.17.zip";
      sha256 = "036kdbaxli1kml5ny7l0viggsaxljhx92gwxdklncg32r2c12x8q";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Belarusian";
      longDescription = ''
        Belarusian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-am_et = mkKodiPlugin {
    plugin = "resource-language-am_et";
    namespace = "resource.language.am_et";
    version = "9.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.am_et/resource.language.am_et-9.0.9.zip";
      sha256 = "0j1cn46iz96nc9i1030lk5dpiav452w08j7vlk16vicmgqwjdacc";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Amharic";
      longDescription = ''
        Amharic version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ar_sa = mkKodiPlugin {
    plugin = "resource-language-ar_sa";
    namespace = "resource.language.ar_sa";
    version = "9.0.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ar_sa/resource.language.ar_sa-9.0.10.zip";
      sha256 = "1r8xd6f517wa05irg3bknkpvdz084ggjsyf6rh4mcv4x1fqi0yyg";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Arabic";
      longDescription = ''
        Arabic version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  script-transmission = mkKodiPlugin {
    plugin = "script-transmission";
    namespace = "script.transmission";
    version = "1.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.transmission/script.transmission-1.0.2.zip";
      sha256 = "0ck8r1i8xbkhjrx0q36r6znd5ngm9p334xwh340l72ga1lkg087w";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3
      script-module-six # version 1.14.0
    ];
    meta = with lib; {
      description = "Kodi addon: Transmission Control Panel";
      longDescription = ''
        Transmission Control Panel supports viewing, adding, removing, starting and stopping torrents.
      '';
      platform = platforms.all;
    };
  };
  service-subtitles-supersubtitles = mkKodiPlugin {
    plugin = "service-subtitles-supersubtitles";
    namespace = "service.subtitles.supersubtitles";
    version = "0.0.26";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.supersubtitles/service.subtitles.supersubtitles-0.0.26.zip";
      sha256 = "1xa1qc9jr2wsijypg4giyjjk1dbkzldh2mspih1wi3k1dga0yiyz";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      vfs-libarchive # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Super Subtitles";
      longDescription = ''
        Search and download subtitles from Super Subtitles (feliratok.info)
      '';
      homepage = "https://www.feliratok.info/index.php";
      platform = platforms.all;
    };
  };
  plugin-video-media-ccc-de = mkKodiPlugin {
    plugin = "plugin-video-media-ccc-de";
    namespace = "plugin.video.media-ccc-de";
    version = "0.2.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.media-ccc-de/plugin.video.media-ccc-de-0.2.0+matrix.1.zip";
      sha256 = "11f65i1qfwxn8bh3klr0fjyjckibljs6hzy4m1rjw2lfdrvm2rrc";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
      script-module-routing # version 0.2.3
    ];
    meta = with lib; {
      description = "Kodi addon: media.ccc.de";
      longDescription = ''
        This addon provides access to videos published on https://media.ccc.de/ (mostly lecture recordings of CCC events)
      '';
      homepage = "https://media.ccc.de/";
      platform = platforms.all;
    };
  };
  screensaver-kaster = mkKodiPlugin {
    plugin = "screensaver-kaster";
    namespace = "screensaver.kaster";
    version = "1.3.5+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.kaster/screensaver.kaster-1.3.5+matrix.1.zip";
      sha256 = "0b3av935qn9m5cdh3yqnw7v9prr6y9lzpc3hqmgnpzy7czd1f6kn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Kaster";
      longDescription = ''
        Display beautiful pictures originally from the chromecast screensaver. You can also display your own photos along with its respective information.
      '';
      platform = platforms.all;
    };
  };
  script-tubecast = mkKodiPlugin {
    plugin = "script-tubecast";
    namespace = "script.tubecast";
    version = "1.4.6+matrix.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.tubecast/script.tubecast-1.4.6+matrix.0.zip";
      sha256 = "03i74afr1y6mgdi05g3jyv99ff10rnd06afb7n5yrixwn0clcr7g";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-bottle # version 0.12.0
      script-module-requests # version 2.12.4
      plugin-video-tubed # version 1.0.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: TubeCast";
      longDescription = ''
        An implementation of the Cast V1 protocol in Kodi to act as a player for the Youtube mobile application
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-vrt-radio = mkKodiPlugin {
    plugin = "plugin-audio-vrt-radio";
    namespace = "plugin.audio.vrt.radio";
    version = "0.1.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.vrt.radio/plugin.audio.vrt.radio-0.1.4+matrix.1.zip";
      sha256 = "1ngap1i7pbhglcdpbylijianjbwjsyb3k31h307rrz24wyw5425y";
    };
    propagatedBuildInputs = [
      script-module-routing # version 0.2.0
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: VRT Radio";
      longDescription = ''
        With this addon you can browse and liste the VRT Radio streams.
      '';
      homepage = "https://github.com/add-ons/plugin.audio.vrt.radio/wiki";
      platform = platforms.all;
    };
  };
  service-subtitles-rvm-addic7ed = mkKodiPlugin {
    plugin = "service-subtitles-rvm-addic7ed";
    namespace = "service.subtitles.rvm.addic7ed";
    version = "3.1.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.rvm.addic7ed/service.subtitles.rvm.addic7ed-3.1.4+matrix.1.zip";
      sha256 = "1pryrdb8vf4y6g0j9i632kshxr4gklm7dnrd4n2qzmn3mklrr8jx";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version None
      script-module-html5lib # version None
      script-module-requests # version None
      script-module-six # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: Addic7ed.com";
      longDescription = ''
        Subtitles service for Addic7ed.com. It supports only TV shows.
      '';
      homepage = "www.addic7ed.com";
      platform = platforms.all;
    };
  };
  script-xbmc-unpausejumpback = mkKodiPlugin {
    plugin = "script-xbmc-unpausejumpback";
    namespace = "script.xbmc.unpausejumpback";
    version = "3.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.xbmc.unpausejumpback/script.xbmc.unpausejumpback-3.0.1.zip";
      sha256 = "082jjmq4d63fa2jvqf61663nypkqn2wyr6xvcy2y727cmqvw52p0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Unpause Jumpback";
      longDescription = ''
        This addon will jump back a number of seconds whenever a video is un-paused - to make sure you don't miss anything.
                You can set the amount of seconds to jump back, and the minimum duration of the pause before the addon will trigger a jump back.
                It also allows to jump back or forward after rewind or fast-forward of a specified amount of seconds to compensate for over-shooting.
                (Originally created by Memphiz, up-keep taken over by bossanova808 in 2020 for Kodi Matrix and beyond).
      '';
      homepage = "https://github.com/bossanova808/script.xbmc.unpausejumpback/";
      platform = platforms.all;
    };
  };
  script-module-inputstreamhelper = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-inputstreamhelper";
    namespace = "script.module.inputstreamhelper";
    version = "0.5.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.inputstreamhelper/script.module.inputstreamhelper-0.5.2+matrix.1.zip";
      sha256 = "18lkksljfa57w69yklbldf7dgyykrm84pd10mdjdqdm88fdiiijk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: InputStream Helper";
      longDescription = ''
        A simple Kodi module that makes life easier for add-on developers relying on InputStream based add-ons and DRM playback.
      '';
      homepage = "https://github.com/emilsvennesson/script.module.inputstreamhelper/wiki";
      platform = platforms.all;
    };
  });
  plugin-video-nhklive = mkKodiPlugin {
    plugin = "plugin-video-nhklive";
    namespace = "plugin.video.nhklive";
    version = "4.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.nhklive/plugin.video.nhklive-4.0.2.zip";
      sha256 = "0an1nfichryxfkgib21bjpdbqgygfj49v1iz174zlibxmp6njfmw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.4
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: NHK Live";
      longDescription = ''
        NHK World Japan Live
      '';
      homepage = "https://www3.nhk.or.jp/";
      platform = platforms.all;
    };
  };
  plugin-video-orftvthek = mkKodiPlugin {
    plugin = "plugin-video-orftvthek";
    namespace = "plugin.video.orftvthek";
    version = "0.11.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.orftvthek/plugin.video.orftvthek-0.11.0.zip";
      sha256 = "18n3synh6s6n5wlyxy9na6zwdd0plryb3p7yhvi73kc96w02cgsn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-future # version 0.16.0
      script-module-kodi-six # version 0.1.3.1
      script-module-simplejson # version 2.0.10
    ];
    meta = with lib; {
      description = "Kodi addon: ORF TVthek";
      longDescription = ''
        ORF TVthek - This plugin provides access to the Austrian "ORF TVthek"
      '';
      homepage = "https://tvthek.orf.at";
      platform = platforms.all;
    };
  };
  plugin-audio-radio_de = mkKodiPlugin {
    plugin = "plugin-audio-radio_de";
    namespace = "plugin.audio.radio_de";
    version = "3.0.5+matrix.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.radio_de/plugin.audio.radio_de-3.0.5+matrix.0.zip";
      sha256 = "1x0n3i67zqpih86gl1zs7ah4im4rg1rs12wnaxdvbdiqhwf7b50k";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-xbmcswift2 # version 19.0.4
    ];
    meta = with lib; {
      description = "Kodi addon: Radio";
      longDescription = ''
        Music plugin to access over 30000 international radio broadcasts from rad.io, radio.de, radio.fr, radio.pt and radio.es[CR]Currently features[CR]- English, german, french translated[CR]- Browse stations by location, genre, topic, country, city and language[CR]- Search for stations[CR]- 115 genres, 59 topics, 94 countrys, 1010 citys, 63 languages
      '';
      homepage = "https://www.radio.de";
      platform = platforms.all;
    };
  };
  script-module-xbmcswift2 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-xbmcswift2";
    namespace = "script.module.xbmcswift2";
    version = "19.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.xbmcswift2/script.module.xbmcswift2-19.0.4.zip";
      sha256 = "13a7wy21ckdqc8ripaanf6k2xf4dx0yl1qimdrbylqs0iba3300k";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: xbmcswift2";
      longDescription = ''
        xbmcswift2 is a small framework to ease development of KODI addons.
      '';
      platform = platforms.all;
    };
  });
  plugin-video-nbcsnliveextra = mkKodiPlugin {
    plugin = "plugin-video-nbcsnliveextra";
    namespace = "plugin.video.nbcsnliveextra";
    version = "2020.11.6+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.nbcsnliveextra/plugin.video.nbcsnliveextra-2020.11.6+matrix.1.zip";
      sha256 = "0iqq8na5d34mdxpmyg6rsrkxv415drqa7qzv0zp30ckamx15knjn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-adobepass # version None
      script-module-requests # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: NBC Sports Live Extra";
      longDescription = ''
        NBC Sports Live Extra is a service that allows you to watch NBC Sports coverage of live events from NBC and NBCSports Network
      '';
      platform = platforms.all;
    };
  };
  plugin-googledrive = mkKodiPlugin {
    plugin = "plugin-googledrive";
    namespace = "plugin.googledrive";
    version = "1.4.10+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.googledrive/plugin.googledrive-1.4.10+matrix.2.zip";
      sha256 = "0dp2lqrfw58rgnypzrhyh9cgxmxm2zfmp0w98abf1fj3adym3gfc";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-clouddrive-common # version 1.3.9+matrix.2
    ];
    meta = with lib; {
      description = "Kodi addon: Google Drive";
      longDescription = ''
        Play all your media from Google Drive including Videos, Music and Pictures (including Google Photos).
         - Unlimited number of accounts.
         - Team Drives support
         - Google Photos support
         - Search over your drive.
         - Auto-Refreshed slideshow.
         - Export your videos to your library (.strm files)
         - Use Google Drive as a source
         - This program is not affiliated with or sponsored by Google.
      '';
      homepage = "https://addons.kodi.tv/show/plugin.googledrive";
      platform = platforms.all;
    };
  };
  plugin-onedrive = mkKodiPlugin {
    plugin = "plugin-onedrive";
    namespace = "plugin.onedrive";
    version = "2.2.8+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.onedrive/plugin.onedrive-2.2.8+matrix.2.zip";
      sha256 = "0mvjs6bmmpgkvh10ssnpxv5xsp3k2rl82ry9iws3cx4jsshdvs5w";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-clouddrive-common # version 1.3.9+matrix.2
    ];
    meta = with lib; {
      description = "Kodi addon: OneDrive";
      longDescription = ''
        Play all your media from OneDrive including Videos, Music and Pictures.
         - Unlimited number of personal or business accounts.
         - Search over your drive.
         - Auto-Refreshed slideshow.
         - Export your videos to your library (.strm files)
         - Use OneDrive as a source
         - This program is not affiliated with or sponsored by Microsoft.
      '';
      homepage = "https://addons.kodi.tv/show/plugin.onedrive";
      platform = platforms.all;
    };
  };
  plugin-audio-radiothek = mkKodiPlugin {
    plugin = "plugin-audio-radiothek";
    namespace = "plugin.audio.radiothek";
    version = "0.1.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.radiothek/plugin.audio.radiothek-0.1.0.zip";
      sha256 = "1ly294xhpqgcwphmyqw55wz6w47d3d8nr8cdyc6yisx7ixi02aia";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: ORF Radiothek";
      longDescription = ''
        This is a Kodi Addon to provides access to the ORF Radiothek (Austrian public service broadcaster) Streaming Portal (Live Radio, Podcasts, Archive, ...).
      '';
      homepage = "https://radiothek.orf.at";
      platform = platforms.all;
    };
  };
  script-module-clouddrive-common = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-clouddrive-common";
    namespace = "script.module.clouddrive.common";
    version = "1.3.9+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.clouddrive.common/script.module.clouddrive.common-1.3.9+matrix.2.zip";
      sha256 = "1jknn15k2xhjhkis12l6fyga942fhzshhlm2l1iw465x5s9pprfm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version None
      script-module-pyqrcode # version None
    ];
    meta = with lib; {
      description = "Kodi addon: Cloud Drive Common Module";
      longDescription = ''
        Common Services and Classes for all the cloud drive addons.
      '';
      platform = platforms.all;
    };
  });
  plugin-video-formula1 = mkKodiPlugin {
    plugin = "plugin-video-formula1";
    namespace = "plugin.video.formula1";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.formula1/plugin.video.formula1-2.0.0.zip";
      sha256 = "0zvanzzm3fc3wa3ccz21j68ck0k6qphlng7vikj945pmlwiasxjf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Formula 1";
      homepage = "https://www.formula1.com";
      platform = platforms.all;
    };
  };
  plugin-video-yelo = mkKodiPlugin {
    plugin = "plugin-video-yelo";
    namespace = "plugin.video.yelo";
    version = "1.0.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.yelo/plugin.video.yelo-1.0.1+matrix.1.zip";
      sha256 = "1mhk0aqdwfbl7gwym035x8vcmcmhz63dj05bdcncqvczzc7aw1vp";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.4.2
      script-module-inputstreamhelper # version 0.5.1
      script-module-requests # version 2.18.0
      script-module-routing # version 0.2.3
    ];
    meta = with lib; {
      description = "Kodi addon: Yelo";
      longDescription = ''
        This plugin makes it possible to watch live streams that are available on the Telenet Yelo application for your region.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-filmstrip-hd-colour = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-filmstrip-hd-colour";
    namespace = "resource.images.moviegenreicons.filmstrip-hd.colour";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.filmstrip-hd.colour/resource.images.moviegenreicons.filmstrip-hd.colour-0.0.2.zip";
      sha256 = "1nsrrhkj1g84qsld1d9wgff2cgvq4cbwiazg1d0pzxmqag0wxg3w";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Filmstrip HD - coloured";
      longDescription = ''
        Filmstrip coloured movie genre icons created by bsoriano. Template by Mr. V, based on the original concept by frodo18.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-filmstrip-hd-bw = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-filmstrip-hd-bw";
    namespace = "resource.images.moviegenreicons.filmstrip-hd.bw";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.filmstrip-hd.bw/resource.images.moviegenreicons.filmstrip-hd.bw-0.0.2.zip";
      sha256 = "05qgf47vjp1v824l8s1j3f99vp1hb88gpfh66n43xgv5prk8c48q";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Filmstrip HD - BW";
      longDescription = ''
        Filmstrip black and white movie genre icons created by bsoriano. Template by Mr. V, based on the original concept by frodo18.
      '';
      platform = platforms.all;
    };
  };
  script-module-simplecache = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-simplecache";
    namespace = "script.module.simplecache";
    version = "2.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.simplecache/script.module.simplecache-2.0.2.zip";
      sha256 = "0sjj5prvm4sq1mfxrx0fpylc3gyn2qbqz9421ifcm7kx5wi83ly5";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Simple Cache Module";
      longDescription = ''
        Provides a simple file- and memory based cache for Kodi addons. Based on the original work of Marcelveldt.
      '';
      platform = platforms.all;
    };
  });
  resource-language-kn_in = mkKodiPlugin {
    plugin = "resource-language-kn_in";
    namespace = "resource.language.kn_in";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.kn_in/resource.language.kn_in-1.0.1.zip";
      sha256 = "1f7jghwdw604vhzvvp1hr6ccaf4bn3pjv8aywrcirg0w02mqb06k";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Kannada";
      longDescription = ''
        Kannada version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ast_es = mkKodiPlugin {
    plugin = "resource-language-ast_es";
    namespace = "resource.language.ast_es";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ast_es/resource.language.ast_es-1.0.1.zip";
      sha256 = "0jrz48binw966s3s1cqixlwb6r68im7nw091hvl88x6rwrdlnqvw";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Asturian";
      longDescription = ''
        Asturian version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  service-subtitles-opensubtitles = mkKodiPlugin {
    plugin = "service-subtitles-opensubtitles";
    namespace = "service.subtitles.opensubtitles";
    version = "5.1.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.opensubtitles/service.subtitles.opensubtitles-5.1.2.zip";
      sha256 = "1vkb0bsiywndhc4v6mgca02jmjyinvl228isyijgl1xg4xl6f0vw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: OpenSubtitles.org";
      longDescription = ''
        Search and download subtitles for movies and TV-Series from OpenSubtitles.org. Search in 75 languages, 4.000.000+ subtitles, daily updates.
      '';
      homepage = "http://www.opensubtitles.org";
      platform = platforms.all;
    };
  };
  script-module-adobepass = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-adobepass";
    namespace = "script.module.adobepass";
    version = "2020.11.6+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.adobepass/script.module.adobepass-2020.11.6+matrix.1.zip";
      sha256 = "1054vvangwlrchrvfrxvlzh0l461618dxr0n1kqfv5vcc1mcw3zx";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: adobepass";
      longDescription = ''
        Simplify Logins authentication services that use adobe primetime (formely adobe pass)
      '';
      platform = platforms.all;
    };
  });
  weather-ozweather = mkKodiPlugin {
    plugin = "weather-ozweather";
    namespace = "weather.ozweather";
    version = "1.2.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/weather.ozweather/weather.ozweather-1.2.2.zip";
      sha256 = "0knd989xc119p457hjlwz47izi92ffjgyy0j85y3ra6xlw3fmass";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-beautifulsoup4 # version 4.8.2+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Oz Weather";
      longDescription = ''
        Weather forecast data scraped from the Australian Bureau of Meteorology via WeatherZone - www.bom.gov.au and www.weatherzone.com.au.  For full features (e.g. radar) make sure you install the replacement skin files found via the addon wiki (https://kodi.wiki/index.php?title=Add-on:Oz_Weather).
      '';
      homepage = "https://kodi.wiki/index.php?title=Add-on:Oz_Weather";
      platform = platforms.all;
    };
  };
  plugin-video-gamekings = mkKodiPlugin {
    plugin = "plugin-video-gamekings";
    namespace = "plugin.video.gamekings";
    version = "1.2.19+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.gamekings/plugin.video.gamekings-1.2.19+matrix.1.zip";
      sha256 = "03gnp63hcps104lg9r8zmkwjy8kg3aijwzlnfbwfj3xz7zpzlz07";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
      plugin-video-youtube # version 5.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: GameKings";
      longDescription = ''
        Watch videos from Gamekings.tv (dutch)
      '';
      homepage = "https://www.gamekings.tv";
      platform = platforms.all;
    };
  };
  resource-images-catchuptvandmore = mkKodiPlugin {
    plugin = "resource-images-catchuptvandmore";
    namespace = "resource.images.catchuptvandmore";
    version = "1.0.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.catchuptvandmore/resource.images.catchuptvandmore-1.0.10.zip";
      sha256 = "0sdazm8wmhwdwdbda0cz9kfrrd8xk15m0kxswj2dg85aa36cfpm5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Catch-up TV & More channel logos and artwork";
      longDescription = ''
        Channel logos and artwork used in Catch-up TV & More
      '';
      homepage = "https://catch-up-tv-and-more.github.io/";
      platform = platforms.all;
    };
  };
  service-libraryautoupdate = mkKodiPlugin {
    plugin = "service-libraryautoupdate";
    namespace = "service.libraryautoupdate";
    version = "1.2.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.libraryautoupdate/service.libraryautoupdate-1.2.1.zip";
      sha256 = "1r52l50mrwxdn4x7whi7g0fmaq8d39y64zsvawk8mfk2qpsqlcsf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.7.3
      script-module-kodi-six # version 0.1.0
      script-module-future # version 0.16.0.4
    ];
    meta = with lib; {
      description = "Kodi addon: Library Auto Update";
      longDescription = ''
        This is a Kodi Service that will update your music and video libraries on a timer. You can select a different interval to scan your media databases (Audio,Video,Both) or you can set a cron-style timer for greater control. If you are playing an audio or video file when the timer starts it can skip the library update process until it is completed so that you're media experience is not interrupted. Updating a specific Video Path, and Cleaning the Music/Video libraries is now supported.
      '';
      platform = platforms.all;
    };
  };
  metadata-themoviedb-org-python = mkKodiPlugin {
    plugin = "metadata-themoviedb-org-python";
    namespace = "metadata.themoviedb.org.python";
    version = "1.3.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.themoviedb.org.python/metadata.themoviedb.org.python-1.3.1+matrix.1.zip";
      sha256 = "0nl2agf1p4nbfzx8c2m32a28jjjyw0xrp4nvap0ak1j64ldb9lyl";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: The Movie Database Python";
      longDescription = ''
        themoviedb.org is a free and open movie database. It's completely user driven by people like you. TMDb is currently used by millions of people every month and with their powerful API, it is also used by many popular media centers like Kodi to retrieve Movie Metadata, Posters and Fanart to enrich the user's experience.
      '';
      homepage = "https://www.themoviedb.org";
      platform = platforms.all;
    };
  };
  script-skinshortcuts = mkKodiPlugin {
    plugin = "script-skinshortcuts";
    namespace = "script.skinshortcuts";
    version = "1.1.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.skinshortcuts/script.skinshortcuts-1.1.4.zip";
      sha256 = "1kcf0bpa5aijz3fvyzhh9gxcrzdfxhknplx67flxvajs38fbssm5";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-unidecode # version 0.4.14
      script-module-simpleeval # version 0.9.10
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Shortcuts";
      longDescription = ''
        Add-on for skins to provide simple managing and listing of user shortcuts (requires skin support)
      '';
      platform = platforms.all;
    };
  };
  plugin-video-composite_for_plex = mkKodiPlugin {
    plugin = "plugin-video-composite_for_plex";
    namespace = "plugin.video.composite_for_plex";
    version = "1.4.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.composite_for_plex/plugin.video.composite_for_plex-1.4.1+matrix.1.zip";
      sha256 = "1631i7rfclbmvfin3jbqw40zmfbgdcfsf760zm3alv2h9r7i87fz";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.0.2
      script-module-six # version 1.11.0
      script-module-requests # version 2.12.4
      script-module-pyxbmct # version 1.2.0
    ];
    meta = with lib; {
      description = "Kodi addon: Composite";
      longDescription = ''
        Browse and play video, music and photo media files managed by Plex Media Server.[CR][CR]Fork of PleXBMC by Hippojay
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-radiorecord = mkKodiPlugin {
    plugin = "plugin-audio-radiorecord";
    namespace = "plugin.audio.radiorecord";
    version = "1.0.0+matrix.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.radiorecord/plugin.audio.radiorecord-1.0.0+matrix.0.zip";
      sha256 = "0s340vm44rpylxsk8n8kbb5kl8ihmkiw8bjanlykrg1dihr1afl2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.4.3
    ];
    meta = with lib; {
      description = "Kodi addon: Radio Record";
      longDescription = ''
        RadioRecord.Ru in your Kodi!
      '';
      homepage = "www.radiorecord.ru";
      platform = platforms.all;
    };
  };
  script-rss-editor = mkKodiPlugin {
    plugin = "script-rss-editor";
    namespace = "script.rss.editor";
    version = "4.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.rss.editor/script.rss.editor-4.0.2.zip";
      sha256 = "0x6h17a3dnkfsjv5h9x8g2gzcakpsy80d2hmzsxd3j58zbbcd6qx";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: RSS Editor";
      longDescription = ''
        A Script for editing Kodi's built in RSS Ticker
      '';
      platform = platforms.all;
    };
  };
  service-scrobbler-lastfm = mkKodiPlugin {
    plugin = "service-scrobbler-lastfm";
    namespace = "service.scrobbler.lastfm";
    version = "4.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.scrobbler.lastfm/service.scrobbler.lastfm-4.0.3.zip";
      sha256 = "0gcg49742a041p51z0hxwr5mca7zpic7fsd4x5p56nqhd562sylh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Last.fm";
      longDescription = ''
        The Last.fm scrobbler will submit info of the songs you've been listening to in Kodi to last.fm
      '';
      platform = platforms.all;
    };
  };
  plugin-video-ytchannels = mkKodiPlugin {
    plugin = "plugin-video-ytchannels";
    namespace = "plugin.video.ytchannels";
    version = "0.3.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.ytchannels/plugin.video.ytchannels-0.3.2+matrix.1.zip";
      sha256 = "1z7m6g0nfvj6gp07kqn8q9vks6wacp7543w9cjf60rmlnhwhcx85";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.11.0
      plugin-video-youtube # version None
    ];
    meta = with lib; {
      description = "Kodi addon: YouTube Channels";
      longDescription = ''
        Watch your favourite YouTube channels and organize them in folders.
      '';
      homepage = "https://github.com/mintsoft/kodi.plugin.ytchannels";
      platform = platforms.all;
    };
  };
  weather-gismeteo = mkKodiPlugin {
    plugin = "weather-gismeteo";
    namespace = "weather.gismeteo";
    version = "0.5.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/weather.gismeteo/weather.gismeteo-0.5.2+matrix.1.zip";
      sha256 = "0km5qz964g5fqghsinnqsmmkav98b56ds88f2i8b77hpx4n1gm8k";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-future # version 0.16.0.4
      script-module-requests # version 2.15.1
    ];
    meta = with lib; {
      description = "Kodi addon: Gismeteo";
      longDescription = ''
        The weather is provided solely for personal non-commercial use
      '';
      homepage = "https://www.gismeteo.com/";
      platform = platforms.all;
    };
  };
  plugin-video-channelsdvr = mkKodiPlugin {
    plugin = "plugin-video-channelsdvr";
    namespace = "plugin.video.channelsdvr";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.channelsdvr/plugin.video.channelsdvr-1.0.8.zip";
      sha256 = "105whvjv1l3pyvbg93ijv57a5wilcwzd78xzpnvs9jz52n9fg9b9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-simplecache # version 1.0.0
      script-module-requests # version 2.7.0
      script-module-inputstreamhelper # version 0.3.3
    ];
    meta = with lib; {
      description = "Kodi addon: Channels DVR";
      longDescription = ''
        Watch your favorite programs on Kodi. Channels delivers a unified experience across all your TVs, devices, and streaming platforms.
      '';
      homepage = "https://getchannels.com/";
      platform = platforms.all;
    };
  };
  metadata-common-imdb-com = mkKodiPlugin {
    plugin = "metadata-common-imdb-com";
    namespace = "metadata.common.imdb.com";
    version = "3.1.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.imdb.com/metadata.common.imdb.com-3.1.6.zip";
      sha256 = "09wj10da27gxdpkjh4h21sbhf8akjdmhvqqfiffqr9mndir0jqar";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: IMDB Scraper Library";
      longDescription = ''
        Download Movie information from www.imdb.com
      '';
      platform = platforms.all;
    };
  };
  plugin-video-southpark_unofficial = mkKodiPlugin {
    plugin = "plugin-video-southpark_unofficial";
    namespace = "plugin.video.southpark_unofficial";
    version = "0.6.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.southpark_unofficial/plugin.video.southpark_unofficial-0.6.3+matrix.1.zip";
      sha256 = "1an4vgd80s571lfb0rha88m3pkvlpdmdn81848qjbx4gvvx5scfw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: South Park";
      longDescription = ''
        Watch South Park episodes. The supported countries are the one that can view videos from https://southpark.cc.com, https://southparkstudios.co.uk, https://southparkstudios.nu or https://www.southpark.de.
      '';
      homepage = "https://southpark.cc.com";
      platform = platforms.all;
    };
  };
  script-speedtester = mkKodiPlugin {
    plugin = "script-speedtester";
    namespace = "script.speedtester";
    version = "1.1.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.speedtester/script.speedtester-1.1.2+matrix.1.zip";
      sha256 = "0skzvmdcrqzg3y5nlqbr2w9ywsp80l446lil48yy739vcbci24w4";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Speed Tester";
      longDescription = ''
        This add-on tests your Internet bandwith and reports both download and upload speeds and latency from within Kodi.

        Use this if you are experiencing streaming issues and you suspect your network to be the cause.
      '';
      homepage = "https://kodi.wiki/view/Add-on:Speed_Tester";
      platform = platforms.all;
    };
  };
  plugin-video-playonbrowser = mkKodiPlugin {
    plugin = "plugin-video-playonbrowser";
    namespace = "plugin.video.playonbrowser";
    version = "2.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.playonbrowser/plugin.video.playonbrowser-2.0.9.zip";
      sha256 = "1j928z5nkj8yabwyw8hg34y8rlnw56yg3k1rwq0k7cy5v68bplbr";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-simplecache # version 1.0.0
      script-module-xmltodict # version 0.9.0
    ];
    meta = with lib; {
      description = "Kodi addon: PlayOn Browser";
      longDescription = ''
        PlayOn is a streaming media brand and software suite that enables users to view and record videos from numerous online content providers.
      '';
      homepage = "https://www.playon.tv";
      platform = platforms.all;
    };
  };
  plugin-video-mlbtv = mkKodiPlugin {
    plugin = "plugin-video-mlbtv";
    namespace = "plugin.video.mlbtv";
    version = "2020.10.8+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.mlbtv/plugin.video.mlbtv-2020.10.8+matrix.1.zip";
      sha256 = "1dy6ifjfp4rx29r144rwxr54c5gf8f28rpx8jw28fiqmh8qjacfb";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pytz # version None
      script-module-beautifulsoup4 # version None
      script-module-requests # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: MLB.TV®";
      longDescription = ''
        Watch every out-of-market regular season game in the office or on the go. The #1 LIVE
                    Streaming Sports Service
      '';
      homepage = "https://www.mlb.com/live-stream-games";
      platform = platforms.all;
    };
  };
  script-pystone-benchmark = mkKodiPlugin {
    plugin = "script-pystone-benchmark";
    namespace = "script.pystone.benchmark";
    version = "1.1.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.pystone.benchmark/script.pystone.benchmark-1.1.2.zip";
      sha256 = "0zzirsv5r76sw8jd3i1m7ifi3rjw5gncf9c39a2k0ks9ssrfpp9y";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
    ];
    meta = with lib; {
      description = "Kodi addon: CPU Benchmark";
      longDescription = ''
        How fast does your device run python code? Pystone evaluates CPU performance running in a python environment.
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-mixcloud = mkKodiPlugin {
    plugin = "plugin-audio-mixcloud";
    namespace = "plugin.audio.mixcloud";
    version = "3.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.mixcloud/plugin.audio.mixcloud-3.0.2.zip";
      sha256 = "1527r0zgcd5vqqdlm6r12dnbwi912viwhlzjr13r0q27m75wf088";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Mixcloud";
      longDescription = ''
        Mixcloud is re-thinking radio. Listen to great radio shows, Podcasts and DJ mix sets on-demand.
      '';
      homepage = "https://www.mixcloud.com";
      platform = platforms.all;
    };
  };
  plugin-video-crackle = mkKodiPlugin {
    plugin = "plugin-video-crackle";
    namespace = "plugin.video.crackle";
    version = "2020.10.7+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.crackle/plugin.video.crackle-2020.10.7+matrix.1.zip";
      sha256 = "1cp57ml51l544mbjxmq5k8ajfpjjb7w9i1ab2p4dspraasva3a2w";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version None
      script-module-inputstreamhelper # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: Crackle";
      longDescription = ''
        Crackle is a video streaming distributor of original web shows, Hollywood movies, and TV shows. Founded in the early 2000s as Grouper, and rebranded in 2007, Crackle is owned by Sony Pictures Entertainment.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-curiositystream = mkKodiPlugin {
    plugin = "plugin-video-curiositystream";
    namespace = "plugin.video.curiositystream";
    version = "2.0.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.curiositystream/plugin.video.curiositystream-2.0.1+matrix.2.zip";
      sha256 = "11mvzfw7s3m9a225jxdh7fpk5scakddg72mnxn6b1yqx0m0jmlj3";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Curiositystream";
      longDescription = ''
        This add-on enables playing content from the CuriosityStream website.
        It requires the user to be subscribed to one of the CuriosityStream plans.
        It is not created, maintained or in any way affiliated with CuriosityStream.
        The add-on only provides an interface to access CuriosityStream media from Kodi.
      '';
      platform = platforms.all;
    };
  };
  skin-confluence = mkKodiPlugin {
    plugin = "skin-confluence";
    namespace = "skin.confluence";
    version = "4.7.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.confluence/skin.confluence-4.7.6.zip";
      sha256 = "020wdw7kl50iwl8430sqsljaxnkgzgq7k739b2cbbji4biv1ivii";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
    ];
    meta = with lib; {
      description = "Kodi addon: Confluence";
      longDescription = ''
        Confluence is a combination of concepts from many popular skins, and attempts to embrace and integrate their good ideas into a skin that should be easy for first time Kodi users to understand and use.
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-shoutcast = mkKodiPlugin {
    plugin = "plugin-audio-shoutcast";
    namespace = "plugin.audio.shoutcast";
    version = "2.5.1+matrix.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.shoutcast/plugin.audio.shoutcast-2.5.1+matrix.0.zip";
      sha256 = "15fw891cf6161la49fczk1irvrb1dr8gmi3cap5h9mh91xjy40r4";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-xbmcswift2 # version 19.0.0
      script-module-xmltodict # version 0.12.0
    ];
    meta = with lib; {
      description = "Kodi addon: SHOUTcast";
      longDescription = ''
        With this Add-on you can browse more than 50.000 free internet radio stations. Current Features:[CR]- Top 500 Stations[CR]- Browse by genre (and subgenre if enabled in settings)[CR]- Search Station by name[CR]- Search Stations by current playing track[CR]- You can manage a "My Stations"-list[CR]- bitrate and amount of listeners visible and sortable[CR]- 500 Stations on each Page (can be changed in the settings)[CR]- uses cache (24h genre, 1h station listings)
      '';
      homepage = "https://www.shoutcast.com/";
      platform = platforms.all;
    };
  };
  script-module-addon-signals = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-addon-signals";
    namespace = "script.module.addon.signals";
    version = "0.0.6+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.addon.signals/script.module.addon.signals-0.0.6+matrix.1.zip";
      sha256 = "1qcjbakch8hvx02wc01zv014nmzgn6ahc4n2bj5mzr114ppd3hjs";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Addon Signals";
      longDescription = ''
        Provides signal/slot mechanism for inter-addon communication
      '';
      platform = platforms.all;
    };
  });
  script-metadata-editor = mkKodiPlugin {
    plugin = "script-metadata-editor";
    namespace = "script.metadata.editor";
    version = "3.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.metadata.editor/script.metadata.editor-3.0.1.zip";
      sha256 = "04y7psyg14hpzzi4ir01a1zbpf3w78j4l2r49ajxp4pyhhgrmz72";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.9.1
    ];
    meta = with lib; {
      description = "Kodi addon: Metadata Editor";
      longDescription = ''
        Helper script to edit basic metadata information of library items with support to automatically update the .nfo file of movies, TV shows, episodes and music videos.
      '';
      platform = platforms.all;
    };
  };
  script-service-next-episode = mkKodiPlugin {
    plugin = "script-service-next-episode";
    namespace = "script.service.next-episode";
    version = "1.2.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.service.next-episode/script.service.next-episode-1.2.3+matrix.1.zip";
      sha256 = "13s7sip2jng2brzwqq1gi54nkf084saw7704dwn4y9chql6vw6vk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pyxbmct # version None
      script-module-requests # version None
      script-module-future # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: Next Episode (next-episode.net)";
      longDescription = ''
        The next-episode.net service for Kodi allows to add your movies and TV episodes from media library to your inventory on next-episode.net. The service also monitors video playback and updates 'watched' status of your movies and episodes on next-episode.net.[CR][B]Note:[/B] The addon works only with Kodi medialibrary!
      '';
      homepage = "http://next-episode.net";
      platform = platforms.all;
    };
  };
  script-globalsearch = mkKodiPlugin {
    plugin = "script-globalsearch";
    namespace = "script.globalsearch";
    version = "9.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.globalsearch/script.globalsearch-9.0.5.zip";
      sha256 = "1i69i01m0lms694bfvlaxji22ybd3qkfx77qlvfby4bkzzhqddr8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Global Search";
      longDescription = ''
        This addon can find any item in your video and music library.
      '';
      platform = platforms.all;
    };
  };
  script-xbmc-lcdproc = mkKodiPlugin {
    plugin = "script-xbmc-lcdproc";
    namespace = "script.xbmc.lcdproc";
    version = "3.90.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.xbmc.lcdproc/script.xbmc.lcdproc-3.90.1.zip";
      sha256 = "19jcznk7vmj3n87ry5a6i032ldaap1irrsfya6cvg420c0ns70i6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: XBMC LCDproc";
      longDescription = ''
        Displays configurable information e.g. about playing media or Kodi status on any LC/VF-display driven by LCDproc, and acts as direct drop-in replacement to the LCD/VFD-feature previously available in Kodi/XBMC's core. Supports additional display elements (icons, bars) on SoundGraph iMON LCD and Targa/Futaba mdm166a VFD hardware. Requires a properly configured and running LCDd either locally or somewhere on the network.
      '';
      homepage = "https://github.com/lcdproc/lcdproc";
      platform = platforms.all;
    };
  };
  plugin-video-imdb-trailers = mkKodiPlugin {
    plugin = "plugin-video-imdb-trailers";
    namespace = "plugin.video.imdb.trailers";
    version = "2.1.12+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.imdb.trailers/plugin.video.imdb.trailers-2.1.12+matrix.1.zip";
      sha256 = "1zhhfbbrkwa98f9fnhyqrwfp2wshr4i91n7qif18w03b9512vjnq";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.4.3
      script-module-requests-cache # version 0.0.1
      script-module-beautifulsoup4 # version 4.0.0
      script-module-six # version 0.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: IMDb Trailers";
      longDescription = ''
        Watch movie trailers available on IMDb
      '';
      homepage = "https://www.imdb.com/trailers/";
      platform = platforms.all;
    };
  };
  metadata-musicvideos-theaudiodb-com = mkKodiPlugin {
    plugin = "metadata-musicvideos-theaudiodb-com";
    namespace = "metadata.musicvideos.theaudiodb.com";
    version = "1.3.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.musicvideos.theaudiodb.com/metadata.musicvideos.theaudiodb.com-1.3.5.zip";
      sha256 = "1mislmsjixzwjk2dlahp40crg2w04frm7j8vyzjvi0yr8y3pgg5b";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-theaudiodb-com # version 1.7.3
    ];
    meta = with lib; {
      description = "Kodi addon: TheAudioDb.com for Music Videos";
      longDescription = ''
        This scraper downloads Music Video information from TheAudioDB.com website. Due to various search difficulties the scraper currently expects the folder/filename to be formatted as 'artist - trackname' otherwise it will not return results. It is important to note the space between the hyphen.
      '';
      homepage = "www.theaudiodb.com";
      platform = platforms.all;
    };
  };
  script-module-future = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-future";
    namespace = "script.module.future";
    version = "0.18.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.future/script.module.future-0.18.2+matrix.1.zip";
      sha256 = "1360274zd0ndhawng9y9sx7r1ndyil8jz244y3m6ghh3pmbvn4a0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: future";
      longDescription = ''
        future is the missing compatibility layer between Python 2 and Python 3. It allows you to use a single, clean Python 3.x-compatible codebase to support both Python 2 and Python 3 with minimal overhead.
      '';
      homepage = "http://python-future.org";
      platform = platforms.all;
    };
  });
  metadata-tvmaze = mkKodiPlugin {
    plugin = "metadata-tvmaze";
    namespace = "metadata.tvmaze";
    version = "1.0.5+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.tvmaze/metadata.tvmaze-1.0.5+matrix.1.zip";
      sha256 = "1gj0hhvaiidakrxp90p04sr5016i2kwcgvimc4yik20cz9ysa9s8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      xbmc-metadata # version 2.1.0
      script-module-six # version None
      script-module-requests # version None
    ];
    meta = with lib; {
      description = "Kodi addon: TVmaze";
      longDescription = ''
        TVmaze is a free user driven TV database curated by TV lovers all over the world. You can track your favorite shows from anywhere.
        We provide an API that can be used by anyone or service like Kodi to retrieve TV Metadata, show/episode/cast images, and much more.
      '';
      homepage = "https://www.tvmaze.com";
      platform = platforms.all;
    };
  };
  metadata-generic-albums = mkKodiPlugin {
    plugin = "metadata-generic-albums";
    namespace = "metadata.generic.albums";
    version = "1.0.13";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.generic.albums/metadata.generic.albums-1.0.13.zip";
      sha256 = "0q03h5wv4910wplqlf656qsplkxy01icfdzpi8fy4bnz3r3y0bwy";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: Generic Album Scraper";
      longDescription = ''
        Searches for album information and artwork across multiple websites.
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-rne = mkKodiPlugin {
    plugin = "plugin-audio-rne";
    namespace = "plugin.audio.rne";
    version = "1.3.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.rne/plugin.audio.rne-1.3.1+matrix.1.zip";
      sha256 = "1kay2j1csff006dq6i61wli5b7zdkq6hjskmwihgmw87isrwl1vi";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: RNE Podcasts";
      longDescription = ''
        This add-on allows you to listen to all the podcast of the emission programmes from the spanish national radio RNE website.[CR]From the add-on settings menu, it can be configured to navigate through all the programmes, or just currently on emission (default).
      '';
      homepage = "https://www.rtve.es/alacarta/rne/";
      platform = platforms.all;
    };
  };
  script-service-checkpreviousepisode = mkKodiPlugin {
    plugin = "script-service-checkpreviousepisode";
    namespace = "script.service.checkpreviousepisode";
    version = "0.4.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.service.checkpreviousepisode/script.service.checkpreviousepisode-0.4.2.zip";
      sha256 = "0bdh5c4x88yfdqrfqgrg3ifahxmcs9550lw2jp7659m603jx1ry9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-yaml # version 3.11.0
    ];
    meta = with lib; {
      description = "Kodi addon: Kodi Check Previous Episode";
      longDescription = ''
        This service helps prevent spoilers by checking if the previous episode in a series has been watched. If not, it will pause playback and warn you.  Specific shows can be marked to be ignored if episode order does not matter.
      '';
      homepage = "https://kodi.wiki/view/Add-on:XBMC_Check_Previous_Episode";
      platform = platforms.all;
    };
  };
  plugin-video-filmsforaction = mkKodiPlugin {
    plugin = "plugin-video-filmsforaction";
    namespace = "plugin.video.filmsforaction";
    version = "1.3.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.filmsforaction/plugin.video.filmsforaction-1.3.1+matrix.1.zip";
      sha256 = "1fjmziqdbblzrs0sgi01r4aal4abd4w18b0yncajd0irw3w3v00v";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      plugin-video-youtube # version 6.8.0
    ];
    meta = with lib; {
      description = "Kodi addon: Films For Action";
      longDescription = ''
        Films For Action is a community-powered learning library and alternative news center for people who want to change the world. It uses the power of film to raise awareness of important social, environmental, and media-related issues not covered by the mainstream news. This Add-on allows you to watch most of its videos.[CR]More than 2,500 videos are available.
      '';
      homepage = "https://www.filmsforaction.org/";
      platform = platforms.all;
    };
  };
  service-watchedlist = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "service-watchedlist";
    namespace = "service.watchedlist";
    version = "1.3.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.watchedlist/service.watchedlist-1.3.2.zip";
      sha256 = "0ikghnskshcwa0yrc8zfllzad4yv55qlbw4dx9lxgd63fazvvdn1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-buggalo # version 1.2.0
      script-module-myconnpy # version 8.0.18
      script-module-dropbox # version 9.4.0
    ];
    meta = with lib; {
      description = "Kodi addon: WatchedList";
      longDescription = ''
        Export: Searches the Kodi-Database for watched files. Determine imdb-id and thetvdb-id to identify movies and TV-episodes. Then save the list to a new independent table.
                Import: Set the watched state for each video file in Kodi.
                Automatic background process without user interaction.
      '';
      homepage = "https://kodi.wiki/view/Add-on:WatchedList";
      platform = platforms.all;
    };
  });
  script-keymap = mkKodiPlugin {
    plugin = "script-keymap";
    namespace = "script.keymap";
    version = "1.1.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.keymap/script.keymap-1.1.3+matrix.1.zip";
      sha256 = "1icrailzpf60nw62xd0khqdp66dnr473m2aa9wzpmkk3qj1ay6jv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-defusedxml # version 0.6.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Keymap Editor";
      longDescription = ''
        Keymap Editor is a GUI for configuring mappings for remotes, keyboard and other inputs supported by Kodi. Note: existing user defined key mappings will be renamed to .bak.
      '';
      platform = platforms.all;
    };
  };
  metadata-generic-artists = mkKodiPlugin {
    plugin = "metadata-generic-artists";
    namespace = "metadata.generic.artists";
    version = "1.0.12";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.generic.artists/metadata.generic.artists-1.0.12.zip";
      sha256 = "0ak6wpsfsflhb9j488pkxi72sjhbc61m2kljgzc6ikipmpd4jiiv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: Generic Artist Scraper";
      longDescription = ''
        Searches for artist information and artwork across multiple websites.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-wabc = mkKodiPlugin {
    plugin = "plugin-video-wabc";
    namespace = "plugin.video.wabc";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.wabc/plugin.video.wabc-4.0.1.zip";
      sha256 = "0agl3cmf3cp6nk5shwp9hj9hjr2bq6r87x81h46q0rxsxhs4rwsg";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: WABC Programs";
      longDescription = ''
        WABC Programs in HD
      '';
      homepage = "abc.com";
      platform = platforms.all;
    };
  };
  plugin-video-freeform = mkKodiPlugin {
    plugin = "plugin-video-freeform";
    namespace = "plugin.video.freeform";
    version = "4.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.freeform/plugin.video.freeform-4.0.2.zip";
      sha256 = "0phxcxj7hws9hlqilm1syvdfyfgv7wlni33d968xb2a0cdkxg0ha";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.2
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: Freeform";
      longDescription = ''
        Freeform Channel Programs in HD
      '';
      homepage = "https://freeform.go.com";
      platform = platforms.all;
    };
  };
  resource-images-studios-white = mkKodiPlugin {
    plugin = "resource-images-studios-white";
    namespace = "resource.images.studios.white";
    version = "0.0.25";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.studios.white/resource.images.studios.white-0.0.25.zip";
      sha256 = "1a2faqjqcvmr8zd0d1jancv3v8kvkkjyxhdfhxgf3gdbgi4rj2cd";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Studio Icons - White";
      longDescription = ''
        White Studio Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-studios-coloured = mkKodiPlugin {
    plugin = "resource-images-studios-coloured";
    namespace = "resource.images.studios.coloured";
    version = "0.0.19";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.studios.coloured/resource.images.studios.coloured-0.0.19.zip";
      sha256 = "0bzclfcnddlc15qdbl69g4d5mc4l0qsjz2skvqx346m4i2167zd7";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Studio Icons - Coloured";
      longDescription = ''
        Coloured Studio Icons
      '';
      platform = platforms.all;
    };
  };
  plugin-video-tweakers = mkKodiPlugin {
    plugin = "plugin-video-tweakers";
    namespace = "plugin.video.tweakers";
    version = "1.1.10+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tweakers/plugin.video.tweakers-1.1.10+matrix.1.zip";
      sha256 = "0vmhy4nvk3zwn3vgvl065db8fvwd34kqx2s1yblpzk8cb3yi8qvs";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.16.0.1
      script-module-html5lib # version 0.999.0
    ];
    meta = with lib; {
      description = "Kodi addon: Tweakers";
      longDescription = ''
        Watch tech videos from Tweakers.net (dutch)
      '';
      homepage = "https://www.tweakers.net";
      platform = platforms.all;
    };
  };
  plugin-video-tekthing = mkKodiPlugin {
    plugin = "plugin-video-tekthing";
    namespace = "plugin.video.tekthing";
    version = "1.0.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tekthing/plugin.video.tekthing-1.0.4+matrix.1.zip";
      sha256 = "178skdn7qa2wlv9qzbn4n2z8r0fgw4ff43wkj7v78zd8rg0mrvjr";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      xbmc-addon # version 12.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
    ];
    meta = with lib; {
      description = "Kodi addon: Tekthing";
      longDescription = ''
        Whether tech is a passion, or something you deal with because you have to, you'll find something useful in every episode of TekThing: product reviews, how-to's, breakdowns on the big stories, and interviews with best experts around!
      '';
      homepage = "http://tekthing.com";
      platform = platforms.all;
    };
  };
  plugin-video-roosterteeth = mkKodiPlugin {
    plugin = "plugin-video-roosterteeth";
    namespace = "plugin.video.roosterteeth";
    version = "1.5.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.roosterteeth/plugin.video.roosterteeth-1.5.0+matrix.1.zip";
      sha256 = "0zcc95ccnwggwybis64ixgfw89ard3x7qflvj9hxin94rghr1l5g";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
      inputstream-adaptive # version 2.3.17
    ];
    meta = with lib; {
      description = "Kodi addon: Rooster Teeth";
      longDescription = ''
        Watch funny videos from RoosterTeeth.com
      '';
      homepage = "https://roosterteeth.com";
      platform = platforms.all;
    };
  };
  plugin-video-powerunlimited = mkKodiPlugin {
    plugin = "plugin-video-powerunlimited";
    namespace = "plugin.video.powerunlimited";
    version = "1.0.7+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.powerunlimited/plugin.video.powerunlimited-1.0.7+matrix.1.zip";
      sha256 = "17jhw960ll1882fr2a0rib93jjhiiqc73f2i2ljsyrcgpgyzvjpb";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
      plugin-video-youtube # version 5.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: PowerUnlimited Tv";
      longDescription = ''
        Watch videos from PowerUnlimited Tv (dutch)
      '';
      homepage = "http://www.pu.nl/";
      platform = platforms.all;
    };
  };
  plugin-video-wsj = mkKodiPlugin {
    plugin = "plugin-video-wsj";
    namespace = "plugin.video.wsj";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.wsj/plugin.video.wsj-4.0.0.zip";
      sha256 = "1mk29hzam5c5ysmx83n7r5q0s7q9y8fqnynpghy9qmlgh0mas1ga";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.5
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: Wall Street Journal Live";
      longDescription = ''
        The Wall Street Journal Live Kodi Add-on
      '';
      homepage = "www.wsj.com";
      platform = platforms.all;
    };
  };
  plugin-video-rt = mkKodiPlugin {
    plugin = "plugin-video-rt";
    namespace = "plugin.video.rt";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.rt/plugin.video.rt-4.0.0.zip";
      sha256 = "1hy8jyvi3wwlma6yp0ffksslzawavpsvicpwyzlgz744f2ykf16q";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Russia Today News";
      longDescription = ''
        Russia Today News Kodi Plugin. RT presents round-the-clock news bulletins, documentaries, talk shows, and debates, as well as sports news and cultural programs on Russia aimed at the overseas news market.
      '';
      homepage = "https://www.rt.com";
      platform = platforms.all;
    };
  };
  plugin-video-nlhardwareinfo = mkKodiPlugin {
    plugin = "plugin-video-nlhardwareinfo";
    namespace = "plugin.video.nlhardwareinfo";
    version = "1.0.8+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.nlhardwareinfo/plugin.video.nlhardwareinfo-1.0.8+matrix.1.zip";
      sha256 = "13n7326zklr68zfw29plg25z17ywym4q6zzmgxv78qglz46943yh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
      plugin-video-youtube # version 5.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: Hardware.Info TV";
      longDescription = ''
        Hardware.Info TV is a webcast in which the editors of Hardware.Info discuss the latest hardware, gadgets and consumer electronics. This plugin lets you view Hardware.Info TV episodes in HD quality via Kodi.
      '';
      homepage = "http://nl.hardware.info/";
      platform = platforms.all;
    };
  };
  plugin-video-wrallocal = mkKodiPlugin {
    plugin = "plugin-video-wrallocal";
    namespace = "plugin.video.wrallocal";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.wrallocal/plugin.video.wrallocal-4.0.1.zip";
      sha256 = "00p7qnxhpfs8xvsq573y6f0wc5k6sr2ygggz162m9x32w2xp1sk0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: WRAL Local Weather and News";
      longDescription = ''
        Get current WRAL News and Weather.
      '';
      homepage = "www.wral.com";
      platform = platforms.all;
    };
  };
  plugin-video-gamegurumania = mkKodiPlugin {
    plugin = "plugin-video-gamegurumania";
    namespace = "plugin.video.gamegurumania";
    version = "1.0.7+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.gamegurumania/plugin.video.gamegurumania-1.0.7+matrix.1.zip";
      sha256 = "04784fzksrfcdafghh3a9bzhvvmwalpcp2d4ws9ghs2ark118196";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
      plugin-video-youtube # version 5.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: Gamegurumania";
      longDescription = ''
        Watch game videos made from ggmania.com
      '';
      homepage = "http://ggmania.com";
      platform = platforms.all;
    };
  };
  script-skin-info-service = mkKodiPlugin {
    plugin = "script-skin-info-service";
    namespace = "script.skin.info.service";
    version = "1.1.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.skin.info.service/script.skin.info.service-1.1.2.zip";
      sha256 = "1zl2jmdi1hn5d6wfja8l13sa3db5vvrkb437qk6gff3akd8hkcx7";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Info Service";
      longDescription = ''
        This script fetches extended information for several media types (artists, albums, movie sets etc.). Needs skin support.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-cnet-podcasts = mkKodiPlugin {
    plugin = "plugin-video-cnet-podcasts";
    namespace = "plugin.video.cnet.podcasts";
    version = "1.1.6+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.cnet.podcasts/plugin.video.cnet.podcasts-1.1.6+matrix.1.zip";
      sha256 = "1iyg2asd48s09cp5rckmfk9fkxb83kb0812r2rpxz4vj4mbjwdyx";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
    ];
    meta = with lib; {
      description = "Kodi addon: CNET Podcasts";
      longDescription = ''
        www.cnet.com/who-we-are/CNET shows you the exciting possibilities of how technology can enhance and enrich your life. We provide you with information, tools, and advice that help you decide what to buy and how to get the most out of your tech.
      '';
      homepage = "http://www.cnet.com/cnet-podcasts";
      platform = platforms.all;
    };
  };
  plugin-video-dumpert = mkKodiPlugin {
    plugin = "plugin-video-dumpert";
    namespace = "plugin.video.dumpert";
    version = "1.1.10+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.dumpert/plugin.video.dumpert-1.1.10+matrix.1.zip";
      sha256 = "0qh8b7zgz0vj7x8cgn9d1sagyxd88rsl00hxkpgy1fsnnsz3x5iv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
      plugin-video-youtube # version 5.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: Dumpert";
      longDescription = ''
        Watch funny videos from Dumpert.nl (dutch)
      '';
      homepage = "https://dumpert.nl";
      platform = platforms.all;
    };
  };
  plugin-video-cbc = mkKodiPlugin {
    plugin = "plugin-video-cbc";
    namespace = "plugin.video.cbc";
    version = "4.0.6+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.cbc/plugin.video.cbc-4.0.6+matrix.1.zip";
      sha256 = "1ai8578w9ky4xlc61096mvbhr1zqj6mcfasp4w1cf859hbaf4g9c";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
      script-module-inputstreamhelper # version 0.4.4
    ];
    meta = with lib; {
      description = "Kodi addon: Canadian Broadcasting Corp (CBC)";
      longDescription = ''
        View online content from the Canadian Broadcasting Corporation.
      '';
      homepage = "https://watch.cbc.ca/";
      platform = platforms.all;
    };
  };
  plugin-video-foodnetwork-canada = mkKodiPlugin {
    plugin = "plugin-video-foodnetwork-canada";
    namespace = "plugin.video.foodnetwork.canada";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.foodnetwork.canada/plugin.video.foodnetwork.canada-4.0.0.zip";
      sha256 = "1plmhq525bgdcfym0ak7p6a0p46r508kvrq91ljyf6m6l39631wf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: Food Network Canada";
      longDescription = ''
        GEO-RESTRICTED: ONLY FOR USE IN CANADA. Play videos from the Food Network Canada Network
      '';
      homepage = "https://www.foodnetwork.ca";
      platform = platforms.all;
    };
  };
  plugin-video-gq = mkKodiPlugin {
    plugin = "plugin-video-gq";
    namespace = "plugin.video.gq";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.gq/plugin.video.gq-4.0.0.zip";
      sha256 = "18v6i25c7bdyf55jv0lyimlpqiglx4ldwj1dyvqnibqzh72zv33i";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: GQ";
      longDescription = ''
        GQ (formerly Gentlemen's Quarterly) is an American monthly men's magazine focusing on fashion, style, and culture for men, through articles on food, movies, fitness, sex, music, travel, sports, technology, and books.
      '';
      homepage = "https://www.gq.com/";
      platform = platforms.all;
    };
  };
  plugin-video-tvo = mkKodiPlugin {
    plugin = "plugin-video-tvo";
    namespace = "plugin.video.tvo";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tvo/plugin.video.tvo-4.0.0.zip";
      sha256 = "034423bfz8r6w62z6c2m2qpjlh1j329nidl0l2qfi0i91wkdakgi";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: TV Ontario";
      longDescription = ''
        TVO is Ontario's public educational media organization and a trusted source of interactive educational content that informs, inspires, and stimulates curiosity.
      '';
      homepage = "tvo.org";
      platform = platforms.all;
    };
  };
  plugin-video-tvokids = mkKodiPlugin {
    plugin = "plugin-video-tvokids";
    namespace = "plugin.video.tvokids";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tvokids/plugin.video.tvokids-4.0.0.zip";
      sha256 = "18vb0m86mnc8m9wjd67lasc7gdk94qqz0mh2bhpjrh71vf26j91i";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: TV Ontario Kids";
      longDescription = ''
        TVO is Ontario's public educational media organization and a trusted source of interactive educational content that informs, inspires, and stimulates curiosity.
      '';
      homepage = "tvo.org";
      platform = platforms.all;
    };
  };
  plugin-image-dumpert = mkKodiPlugin {
    plugin = "plugin-image-dumpert";
    namespace = "plugin.image.dumpert";
    version = "1.0.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.image.dumpert/plugin.image.dumpert-1.0.4+matrix.1.zip";
      sha256 = "08l2crrsk74y0gg32ksga6sm0f5w3mirbqzjvc5mgprnckqdp6x3";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.3.2
      script-module-requests # version 2.4.3
      script-module-future # version 0.0.1
      script-module-html5lib # version 0.999.0
    ];
    meta = with lib; {
      description = "Kodi addon: Dumpert";
      longDescription = ''
        Watch funny pictures from Dumpert.nl (dutch)
      '';
      homepage = "https://dumpert.nl";
      platform = platforms.all;
    };
  };
  resource-images-classificationicons-colour = mkKodiPlugin {
    plugin = "resource-images-classificationicons-colour";
    namespace = "resource.images.classificationicons.colour";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.classificationicons.colour/resource.images.classificationicons.colour-0.0.3.zip";
      sha256 = "1a3c8c5snr1rb9dxskbnyb0zj5gf70a5xhzi51w72n5awq2dydp3";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Classification Icons - Colour";
      longDescription = ''
        Colour square aspect (64x64) video classification icons for use with MPAA ListItem in Kodi. Can be used by Kodi skins using skin variables to show icons or the much quicker $INFO as a texture method. Details of usage and supported icons in the README.md file.
      '';
      platform = platforms.all;
    };
  };
  metadata-tvdb-com = mkKodiPlugin {
    plugin = "metadata-tvdb-com";
    namespace = "metadata.tvdb.com";
    version = "3.2.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.tvdb.com/metadata.tvdb.com-3.2.8.zip";
      sha256 = "1mzj100f56yxs7whsnw19lf5bnfw863bq6xa574qn3jvqkk8p7rm";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-imdb-com # version 2.9.2
    ];
    meta = with lib; {
      description = "Kodi addon: The TVDB";
      longDescription = ''
        TheTVDB.com is a TV Scraper. The site is a massive open database that can be modified by anybody and contains full meta data for many shows in different languages. All content and images on the site have been contributed by their users for users and have a high standard or quality. The database schema and website are open source under the GPL.
      '';
      homepage = "https://www.thetvdb.com";
      platform = platforms.all;
    };
  };
  screensaver-turnoff = mkKodiPlugin {
    plugin = "screensaver-turnoff";
    namespace = "screensaver.turnoff";
    version = "0.10.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.turnoff/screensaver.turnoff-0.10.3+matrix.1.zip";
      sha256 = "1ywsm1qxv9bad8pwrd4ifybwqc68vf6jbpmgj6i75hqx04y9ygdg";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Turn Off";
      longDescription = ''
        The Turn Off screensaver turns your TV, projector or screen off, like any old fashioned screensaver is intended to do.

        Next to managing your display, it can also manage your device power state, log your profile off or mute audio to avoid sounds through your A/V receiver.
      '';
      homepage = "https://kodi.wiki/view/Add-on:Turn_Off";
      platform = platforms.all;
    };
  };
  script-module-autocompletion = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-autocompletion";
    namespace = "script.module.autocompletion";
    version = "2.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.autocompletion/script.module.autocompletion-2.0.2.zip";
      sha256 = "1igi21jpyw0248bzqc3a0zd975ljn6rjhgdmk04dq5n0hkawim85";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.9.1
    ];
    meta = with lib; {
      description = "Kodi addon: AutoCompletion library";
      longDescription = ''
        Module providing some AutoCompletion functions
      '';
      platform = platforms.all;
    };
  });
  plugin-video-npr = mkKodiPlugin {
    plugin = "plugin-video-npr";
    namespace = "plugin.video.npr";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.npr/plugin.video.npr-4.0.1.zip";
      sha256 = "10nnwz3nr4w39inxv1mi1py7lk6rbk9v8jhf6d12p5cp1pnbdxb1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.6
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: NPR Music Videos";
      longDescription = ''
        NPR Music launched in November 2007 to present public radio music programming and original editorial content for music discovery. It is a project of National Public Radio, a privately and publicly funded non-profit membership media organization that serves as a national syndicator to public radio stations in the United States.
      '';
      homepage = "https://www.npr.org/music/";
      platform = platforms.all;
    };
  };
  plugin-video-regiotv = mkKodiPlugin {
    plugin = "plugin-video-regiotv";
    namespace = "plugin.video.regiotv";
    version = "0.1.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.regiotv/plugin.video.regiotv-0.1.2+matrix.1.zip";
      sha256 = "0327ncqlvhsb98wl4cg6h680x6bwzpi3y680b0zys4rzr099321y";
    };
    propagatedBuildInputs = [
      script-module-routing # version 0.2.3
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Regio TV";
      longDescription = ''
        The Regio TV add-on lists all available Flemish regional television stations.

        Available channels: ATV, BRUZZ, Focus TV, ROB-tv, TVL, TV Oost, WTV

        [I]This add-on is not endorsed by any television station, and is provided 'as is' without any warranty of any kind.[/I]
      '';
      homepage = "https://github.com/add-ons/plugin.video.regiotv/wiki";
      platform = platforms.all;
    };
  };
  script-harmony-control = mkKodiPlugin {
    plugin = "script-harmony-control";
    namespace = "script.harmony.control";
    version = "0.2.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.harmony.control/script.harmony.control-0.2.0+matrix.1.zip";
      sha256 = "0sbvb09ydhsz9z1skn1rk9hg6rqb7m940j8cx1xz5rmy27s9dnnj";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
      script-module-requests # version 2.22.0+matrix.1
      script-module-websocket # version 0.5.7+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Harmony Hub Controller";
      longDescription = ''
        Harmony Hub Controller let's you setup actions to run a Harmony activity and/or a sequence of remote commands. Running the addon gives you a menu of your actions, and you can also send an action name as an arg to have the script run a specific action.
      '';
      platform = platforms.all;
    };
  };
  metadata-cinemarx-ro = mkKodiPlugin {
    plugin = "metadata-cinemarx-ro";
    namespace = "metadata.cinemarx.ro";
    version = "1.2.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.cinemarx.ro/metadata.cinemarx.ro-1.2.2.zip";
      sha256 = "0y98almw2zfs22dvf00r6mrqfs56snzxz54bb3x7qrss6hah6zyn";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 1.0
      metadata-common-themoviedb-org # version 3.1.0
      metadata-common-imdb-com # version 2.1.9
    ];
    meta = with lib; {
      description = "Kodi addon: cinemarx";
      longDescription = ''
        Download Movie information from www.cinemarx.ro
      '';
      platform = platforms.all;
    };
  };
  script-check-theme = mkKodiPlugin {
    plugin = "script-check-theme";
    namespace = "script.check.theme";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.check.theme/script.check.theme-0.0.2.zip";
      sha256 = "1nlzxznchhzmb6qylz21i0fiisb1gdf2p9k9i7d3dk6pbnkh2yhc";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Check MP3 Theme";
      longDescription = ''
        Script for skinners to check if a mp3 theme exists.
      '';
      platform = platforms.all;
    };
  };
  plugin-audio-wdr3konzert = mkKodiPlugin {
    plugin = "plugin-audio-wdr3konzert";
    namespace = "plugin.audio.wdr3konzert";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.wdr3konzert/plugin.audio.wdr3konzert-2.0.1.zip";
      sha256 = "0g7rb59lmzbb3kz27j92vk63vi8znhghx5rfncnasapb6np8a4pk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libwdr # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: WDR3 Konzertplayer";
      longDescription = ''
        This add-on lists the concert content of the WD3.
      '';
      homepage = "https://www1.wdr.de/radio/wdr3/konzertplayer/index.html";
      platform = platforms.all;
    };
  };
  plugin-video-dailymotion_com = mkKodiPlugin {
    plugin = "plugin-video-dailymotion_com";
    namespace = "plugin.video.dailymotion_com";
    version = "2.4.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.dailymotion_com/plugin.video.dailymotion_com-2.4.2.zip";
      sha256 = "0pvnvyr10lx6ggh58fjsbxrf49axjxxhhpsnhlifnxjl6i3py6m2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 0.0.1
      script-module-kodi-six # version 0.0.1
      script-module-requests # version 2.4.3
    ];
    meta = with lib; {
      description = "Kodi addon: DailyMotion.com";
      longDescription = ''
        Dailymotion attracts 300 million users from around the world, who watch 3.5 billion videos on its player each month.
      '';
      homepage = "https://www.dailymotion.com";
      platform = platforms.all;
    };
  };
  script-module-websocket = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-websocket";
    namespace = "script.module.websocket";
    version = "0.57.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.websocket/script.module.websocket-0.57.0+matrix.1.zip";
      sha256 = "00a98w0wrxa3y20vqzabhll517fsdi13si3qavvhh12rfgfsib56";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.14.0+matrix.2
    ];
    meta = with lib; {
      description = "Kodi addon: websocket library";
      homepage = "https://github.com/websocket-client/websocket-client";
      platform = platforms.all;
    };
  });
  service-library-data-provider = mkKodiPlugin {
    plugin = "service-library-data-provider";
    namespace = "service.library.data.provider";
    version = "0.4.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.library.data.provider/service.library.data.provider-0.4.1.zip";
      sha256 = "0zia9g6mzsdlx5427vv49kf0zxk1ys29z7glc2n4bvryxhk4v95r";
    };
    propagatedBuildInputs = [
      xbmc-json # version 7.9.0
      xbmc-python # version 3.0.0
      script-module-routing # version 0.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: Library Data Provider";
      longDescription = ''
        Plugin for skins to provide library data throughout the skin. It can also be used as standalone plugin to browse the playlists in the video library.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-wnbc = mkKodiPlugin {
    plugin = "plugin-video-wnbc";
    namespace = "plugin.video.wnbc";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.wnbc/plugin.video.wnbc-4.0.0.zip";
      sha256 = "1w181lgzs4xdlisgnlh3ay49gb23yvd0zkh26k1y3m9fcglaiw9b";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: WNBC Programs";
      longDescription = ''
        WNBC Programs. The Tonight Show, NBC News and NBC Classic TV.
      '';
      homepage = "nbc.com";
      platform = platforms.all;
    };
  };
  skin-aeon-nox-silvo = mkKodiPlugin {
    plugin = "skin-aeon-nox-silvo";
    namespace = "skin.aeon.nox.silvo";
    version = "7.9.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.aeon.nox.silvo/skin.aeon.nox.silvo-7.9.6.zip";
      sha256 = "1zpmrsi81mp1a876s25r9kgpgfzzpigyffrj7c18hnlcmv2apr8m";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
      script-skinshortcuts # version 1.0.10
      service-library-data-provider # version 0.0.7
      resource-images-studios-white # version 0.0.1
      resource-images-recordlabels-white # version 0.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Aeon Nox: SiLVO";
      longDescription = ''
        Completely redesigned to create a modern look, while retaining the classic Aeon feel.
      '';
      homepage = "https://github.com/mikesilvo164/Aeon-Nox-SiLVO";
      platform = platforms.all;
    };
  };
  plugin-video-contv = mkKodiPlugin {
    plugin = "plugin-video-contv";
    namespace = "plugin.video.contv";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.contv/plugin.video.contv-4.0.1.zip";
      sha256 = "1bbx87g53k9abn759nmkqqk29vvpdd2z20kvkfr4jr372pr20vdp";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.2
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: ConTV";
      longDescription = ''
        ConTV
      '';
      homepage = "www.contv.com";
      platform = platforms.all;
    };
  };
  plugin-video-popcornflix = mkKodiPlugin {
    plugin = "plugin-video-popcornflix";
    namespace = "plugin.video.popcornflix";
    version = "7.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.popcornflix/plugin.video.popcornflix-7.0.0.zip";
      sha256 = "1rb3pkznj81kmdfp96082fx9p0fq439ysiy93lzhc41bqhk97090";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.2
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: Popcornflix";
      longDescription = ''
        Popcornflix offers a broad collection of great movies you can watch right now
      '';
      homepage = "https://www.popcornflix.com";
      platform = platforms.all;
    };
  };
  plugin-video-fox-news = mkKodiPlugin {
    plugin = "plugin-video-fox-news";
    namespace = "plugin.video.fox.news";
    version = "7.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.fox.news/plugin.video.fox.news-7.0.0.zip";
      sha256 = "0yz2xarlr40vyhdddirpxgkdfbgy5562km04agf5q85im1vyjbsk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Fox News";
      longDescription = ''
        Fox News Videos
      '';
      homepage = "www.foxnews.com";
      platform = platforms.all;
    };
  };
  plugin-video-buzzr = mkKodiPlugin {
    plugin = "plugin-video-buzzr";
    namespace = "plugin.video.buzzr";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.buzzr/plugin.video.buzzr-4.0.0.zip";
      sha256 = "061wz8pfmv3k14grajd2sk6kagaa5aw8rbpqk8afg0lqams3az3z";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: BUZZR Live";
      longDescription = ''
        BUZZR is a free broadcast network featuring game shows programming.
      '';
      homepage = "buzzr.com";
      platform = platforms.all;
    };
  };
  plugin-video-courttv = mkKodiPlugin {
    plugin = "plugin-video-courttv";
    namespace = "plugin.video.courttv";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.courttv/plugin.video.courttv-4.0.0.zip";
      sha256 = "0h1dr1bw2d8d0xb8rhqwjklp1lblrfxm9ami24ccn2wc0w10l7dg";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Court TV Live";
      longDescription = ''
        Court TV is a broadcast network featuring court room case programming.
      '';
      homepage = "buzzr.com";
      platform = platforms.all;
    };
  };
  plugin-video-dabl = mkKodiPlugin {
    plugin = "plugin-video-dabl";
    namespace = "plugin.video.dabl";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.dabl/plugin.video.dabl-4.0.0.zip";
      sha256 = "1chjs2cdrjk633jsnzqj241vvcax61zjnrigxx31wm98gmhbaif2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: DABL Network Live";
      longDescription = ''
        DABL A New Lifestyle Network
      '';
      homepage = "dabl.com";
      platform = platforms.all;
    };
  };
  plugin-video-lighttv = mkKodiPlugin {
    plugin = "plugin-video-lighttv";
    namespace = "plugin.video.lighttv";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.lighttv/plugin.video.lighttv-4.0.0.zip";
      sha256 = "07is5yn0js2szajmjd41a1nckvs1ps38ihnkigal60waxhxnxj0b";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: LIGHTtv Live";
      longDescription = ''
        LIGHTtv is a new free broadcast network featuring family programming including movies, series and  entertainment.
      '';
      homepage = "lighttv.com";
      platform = platforms.all;
    };
  };
  plugin-video-tbdtv = mkKodiPlugin {
    plugin = "plugin-video-tbdtv";
    namespace = "plugin.video.tbdtv";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.tbdtv/plugin.video.tbdtv-4.0.0.zip";
      sha256 = "0sfc6cy4sl1ryjza2l495jv47xxysn83dzhhr58h4m64g7caafkl";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: TBD TV Live";
      longDescription = ''
        Everything from culinary capers, jaw-dropping action, hilarious pranks and comedy, music, fitness, gaming, or just random awesomeness that you never knew you needed in your life.
      '';
      homepage = "www.tbd.com";
      platform = platforms.all;
    };
  };
  plugin-video-comettv = mkKodiPlugin {
    plugin = "plugin-video-comettv";
    namespace = "plugin.video.comettv";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.comettv/plugin.video.comettv-4.0.0.zip";
      sha256 = "1m8k90q5j2h55likgbazs8fdnwyx04nr4xp63zagn6c1cpjdm4a9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Comet TV Live";
      longDescription = ''
        COMET is a new television channel dedicated to sci-fi entertainment offering popular favorites, cult classics, and undiscovered gems, every day.
      '';
      homepage = "www.comettv.com";
      platform = platforms.all;
    };
  };
  plugin-video-pbskids = mkKodiPlugin {
    plugin = "plugin-video-pbskids";
    namespace = "plugin.video.pbskids";
    version = "4.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.pbskids/plugin.video.pbskids-4.0.1.zip";
      sha256 = "0apmdpg6jki1gdq23hjrsllw6lbwhdplmklh43fi5kvz61wglh91";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: PBS Kids";
      longDescription = ''
        PBS Kids is the most widely used non-profit informational resource in our community.
      '';
      homepage = "video.thinktv.org";
      platform = platforms.all;
    };
  };
  plugin-video-charge = mkKodiPlugin {
    plugin = "plugin-video-charge";
    namespace = "plugin.video.charge";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.charge/plugin.video.charge-4.0.0.zip";
      sha256 = "06x3gix9i9a3rbgyiq846wpljqsx8zgxrbr8sk1nqxw3k3cb93n9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Charge! TV Live";
      longDescription = ''
        CHARGE! is a new free broadcast network featuring action programming including movies, series and sports entertainment.
      '';
      homepage = "www.watchcharge.com";
      platform = platforms.all;
    };
  };
  plugin-video-cook = mkKodiPlugin {
    plugin = "plugin-video-cook";
    namespace = "plugin.video.cook";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.cook/plugin.video.cook-4.0.0.zip";
      sha256 = "1l3g21z2v6ay6q4yqilnmk92izig4vp10aw3ar2mpp7dl92bww1s";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Cooking Channel";
      longDescription = ''
        Cooking Channel
      '';
      homepage = "https://www.cookingchanneltv.com/";
      platform = platforms.all;
    };
  };
  plugin-video-cbcnews = mkKodiPlugin {
    plugin = "plugin-video-cbcnews";
    namespace = "plugin.video.cbcnews";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.cbcnews/plugin.video.cbcnews-4.0.0.zip";
      sha256 = "19s3w7ig1094ialxy659zlhgbsjxzmdaz7nr2j8jwpizag586120";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: CBC.ca News";
      longDescription = ''
        CBC News - only for use in Canada. CBC.ca is Canada's Online Information Source. Comprehensive web site for news, entertainment, sports, and business.
      '';
      homepage = "https://www.cbc.ca";
      platform = platforms.all;
    };
  };
  plugin-video-aswim = mkKodiPlugin {
    plugin = "plugin-video-aswim";
    namespace = "plugin.video.aswim";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.aswim/plugin.video.aswim-4.0.0.zip";
      sha256 = "0xb9ah41lh99sg42axcbjcp6ra6hhrz83wh3dmdbdfdcn7q295f8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
      inputstream-adaptive # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: Adult Swim";
      longDescription = ''
        Adult Swim Channel Kodi Add-on
      '';
      homepage = "www.adultswim.com";
      platform = platforms.all;
    };
  };
  plugin-video-brmediathek = mkKodiPlugin {
    plugin = "plugin-video-brmediathek";
    namespace = "plugin.video.brmediathek";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.brmediathek/plugin.video.brmediathek-2.0.0.zip";
      sha256 = "0yzkdidr1876iw7xpglimn9jvwa4hjc341j159qmvkjw1z14f83k";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libbr # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: BR Mediathek";
      longDescription = ''
        This add-on provides access to the BR Mediathek.
      '';
      homepage = "https://www.br.de/mediathek/";
      platform = platforms.all;
    };
  };
  plugin-video-metv = mkKodiPlugin {
    plugin = "plugin-video-metv";
    namespace = "plugin.video.metv";
    version = "4.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.metv/plugin.video.metv-4.0.0.zip";
      sha256 = "0qv179r0l4n6xbzpl49w82fpd2zvda8rcf59c69h27jvinv56mx9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-t1mlib # version 4.0.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: MeTV";
      longDescription = ''
        Chosen from a wide array of genres, the programs of Me-TV pay tribute to classic television. Comedies like The Mary Tyler Moore Show, I Love Lucy, The Honeymooners and The Bob Newhart Show. Dramas such as Perry Mason, Ironside, The Streets of San Francisco, The Rockford Files and Columbo great westerns like Gunsmoke, Bonanza, The Rifleman and The Big Valley and otherworldly classics like Star Trek, Lost In Space and The Twilight Zone
      '';
      homepage = "www.metv.com";
      platform = platforms.all;
    };
  };
  plugin-audio-arteconcert = mkKodiPlugin {
    plugin = "plugin-audio-arteconcert";
    namespace = "plugin.audio.arteconcert";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.arteconcert/plugin.audio.arteconcert-2.0.1.zip";
      sha256 = "1xjsd4vh46jx7n9s6s3jvk44cg6cldg6n1g19hr1j5kd1nyza879";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libarte # version 2.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Arte Concert";
      longDescription = ''
        This add-on allows access to the concert section of the French/German broadcaster Arte.
      '';
      homepage = "https://www.arte.tv/en/arte-concert/";
      platform = platforms.all;
    };
  };
  plugin-video-artemediathek = mkKodiPlugin {
    plugin = "plugin-video-artemediathek";
    namespace = "plugin.video.artemediathek";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.artemediathek/plugin.video.artemediathek-2.0.1.zip";
      sha256 = "1s3q6habbzywkmnyc2yi56dm5swnqc4f9wwr37vmv9bnwkwsb4yy";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libarte # version 2.0.1
    ];
    meta = with lib; {
      description = "Kodi addon: Arte Mediathek";
      longDescription = ''
        This add-on allows access to the French/German broadcaster Arte.
      '';
      homepage = "https://www.arte.tv/";
      platform = platforms.all;
    };
  };
  script-module-libarte = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-libarte";
    namespace = "script.module.libarte";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.libarte/script.module.libarte-2.0.1.zip";
      sha256 = "1948sq6rvq8fvbll5h2gs4zxcc8kds02vhhgz8ii0133gq1r0h8m";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: libarte";
      longDescription = ''
        This is a scraper for http://arte.tv.
      '';
      platform = platforms.all;
    };
  });
  plugin-video-ardmediathek_de = mkKodiPlugin {
    plugin = "plugin-video-ardmediathek_de";
    namespace = "plugin.video.ardmediathek_de";
    version = "6.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.ardmediathek_de/plugin.video.ardmediathek_de-6.0.0.zip";
      sha256 = "06p2ia73sx3nkpk90p48ks440amnrzpynhbg9f7p23k3597q61w0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libard # version 6.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: ARD Mediathek";
      longDescription = ''
        Watch videos on demand from the ARD Mediathek.
      '';
      homepage = "https://www.ardmediathek.de/";
      platform = platforms.all;
    };
  };
  script-module-trakt = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-trakt";
    namespace = "script.module.trakt";
    version = "4.2.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.trakt/script.module.trakt-4.2.0+matrix.1.zip";
      sha256 = "1hbg1gx0803rlp77ji5rgd14vd11k42j23fxprvs3dnc04whq837";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.15.1
      script-module-six # version 1.10.0
      script-module-arrow # version 0.10.0
    ];
    meta = with lib; {
      description = "Kodi addon: trakt.py";
      longDescription = ''
        Packed for Kodi from https://github.com/fuzeman/trakt.py
      '';
      homepage = "https://github.com/fuzeman/trakt.py";
      platform = platforms.all;
    };
  });
  plugin-audio-wdraudiothek = mkKodiPlugin {
    plugin = "plugin-audio-wdraudiothek";
    namespace = "plugin.audio.wdraudiothek";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.wdraudiothek/plugin.audio.wdraudiothek-2.0.0.zip";
      sha256 = "1frr612xyx0k8wd2gxxmrf08v262243s458jl0jmwg92pxqqrl3a";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libwdr # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: WDR Audiothek";
      longDescription = ''
        This add-on lists the audio content of the WDR Mediathek.
      '';
      homepage = "https://www1.wdr.de/mediathek/audio/index.html";
      platform = platforms.all;
    };
  };
  plugin-video-filmfriend = mkKodiPlugin {
    plugin = "plugin-video-filmfriend";
    namespace = "plugin.video.filmfriend";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.filmfriend/plugin.video.filmfriend-1.0.0.zip";
      sha256 = "1bhkwji9i91mwz3pyhddkqynb3j7qb0jm0qgwgk7arciwksd47m5";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
      inputstream-adaptive # version 2.5.4
    ];
    meta = with lib; {
      description = "Kodi addon: Filmfriend.de";
      longDescription = ''
        This video add-on provides access to shows and movies of Filmfriend.de. A valid library account is reqired in order to use this add-on.
      '';
      homepage = "https://www.filmfriend.de/";
      platform = platforms.all;
    };
  };
  plugin-video-mdrplus = mkKodiPlugin {
    plugin = "plugin-video-mdrplus";
    namespace = "plugin.video.mdrplus";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.mdrplus/plugin.video.mdrplus-1.0.0.zip";
      sha256 = "1pycnj7rayppjnikiicidi20a59sfqmv28fm87pzk4imh9dm6lhx";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: MDR+";
      longDescription = ''
        This add-on provides access to the German VOD platform http://www.mdr.de/.
      '';
      homepage = "https://www.mdr.de/";
      platform = platforms.all;
    };
  };
  script-module-buggalo = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-buggalo";
    namespace = "script.module.buggalo";
    version = "1.2.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.buggalo/script.module.buggalo-1.2.0.zip";
      sha256 = "17n6c93hm6fyi12x6qw2rz02yg1gwbmvjld9lqj9x8fx29rhnmww";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Buggalo Exception Collector";
      longDescription = ''
        This module can collect various information about an exception and the users system such as Kodi and Python versions, etc. and submit it to a url.
      '';
      platform = platforms.all;
    };
  });
  script-service-playbackresumer = mkKodiPlugin {
    plugin = "script-service-playbackresumer";
    namespace = "script.service.playbackresumer";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.service.playbackresumer/script.service.playbackresumer-2.0.1.zip";
      sha256 = "12gdcd4sf3ldirdqq7ry0r2m3kz00a88kn766nv84cb9kycfa4s9";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Kodi Playback Resumer";
      longDescription = ''
        Runs as a service and will periodically update the resume point while videos are playing, so you can re-start from where you were in the event of a crash.  It can also automatically resume a video if Kodi was shutdown while playing it. See setting to configure how often the resume point is set, and whether to automatically resume.
      '';
      homepage = "https://github.com/bossanova808/script.service.playbackresumer";
      platform = platforms.all;
    };
  };
  screensaver-picture-slideshow = mkKodiPlugin {
    plugin = "screensaver-picture-slideshow";
    namespace = "screensaver.picture.slideshow";
    version = "6.3.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/screensaver.picture.slideshow/screensaver.picture.slideshow-6.3.1.zip";
      sha256 = "0rqn5w582qmb0vfnw96xrvhm0gjfxd1qxrzqv88cb9fvxjqi0a5l";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-exifread # version 2.1.2+matrix.0
      script-module-iptcinfo3 # version 2.1.4+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Picture Slideshow Screensaver";
      longDescription = ''
        The Slideshow screensaver will show you a slide show of images using various transition effects. It can be configured to show your libraries music or video fanart, or a custom folder of images
      '';
      platform = platforms.all;
    };
  };
  script-module-exifread = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-exifread";
    namespace = "script.module.exifread";
    version = "2.1.2+matrix.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.exifread/script.module.exifread-2.1.2+matrix.0.zip";
      sha256 = "1h78mw9mvgfhsfzcfvc43ca7ykk5b47p2iibav6cz9h3d54zbbgh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: ExifRead";
      longDescription = ''
        Easy to use Python module to extract Exif metadata from tiff and jpeg files.
      '';
      homepage = "https://pypi.org/project/ExifRead/";
      platform = platforms.all;
    };
  });
  script-module-iptcinfo3 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-iptcinfo3";
    namespace = "script.module.iptcinfo3";
    version = "2.1.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.iptcinfo3/script.module.iptcinfo3-2.1.4+matrix.1.zip";
      sha256 = "09ls630ihw9xqgvyk55gbv4ph9qy0q7w2dgdpyihb2yjzmj6j8wb";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: IPTCInfo3";
      longDescription = ''
        IPTCInfo extracts embedded IPTC meta-information from images files.
      '';
      homepage = "https://pypi.org/project/IPTCInfo3/";
      platform = platforms.all;
    };
  });
  context-trakt-addtowatchlist = mkKodiPlugin {
    plugin = "context-trakt-addtowatchlist";
    namespace = "context.trakt.addtowatchlist";
    version = "1.1.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/context.trakt.addtowatchlist/context.trakt.addtowatchlist-1.1.0+matrix.1.zip";
      sha256 = "0h91vikl4pynd7xiyvix4pavq45fpghm3ci57qc0qy7fqi5vlvwp";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-trakt # version 3.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: Trakt - Add to watchlist button";
      longDescription = ''
        Add Trakt add to watchlist button to the context menu in your library.
      '';
      platform = platforms.all;
    };
  };
  context-trakt-rate = mkKodiPlugin {
    plugin = "context-trakt-rate";
    namespace = "context.trakt.rate";
    version = "1.1.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/context.trakt.rate/context.trakt.rate-1.1.0+matrix.1.zip";
      sha256 = "18bpzd7mlgrxxsvyvh2v2ss58afwhbllzd8ws571mzlpzm11ad4w";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-trakt # version 3.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: Trakt - Rating button";
      longDescription = ''
        Add Trakt rating button to the context menu in your library.
      '';
      platform = platforms.all;
    };
  };
  context-trakt-watched = mkKodiPlugin {
    plugin = "context-trakt-watched";
    namespace = "context.trakt.watched";
    version = "1.1.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/context.trakt.watched/context.trakt.watched-1.1.0+matrix.1.zip";
      sha256 = "1a7l2fdcpr4z7v2avz2kkl5l87spfv6mr2dbkl8kp0rhbrm61ffd";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-trakt # version 3.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: Trakt - Watched button";
      longDescription = ''
        Add Trakt watched button to context menu in library. Needs script.trakt installed and activated.
      '';
      platform = platforms.all;
    };
  };
  script-logviewer = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-logviewer";
    namespace = "script.logviewer";
    version = "2.1.4+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.logviewer/script.logviewer-2.1.4+matrix.1.zip";
      sha256 = "1qkkary38p0a7zz9bzdgxfa8bwpjf46ilibf7gdl7r02nmknfdgr";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Log Viewer for Kodi";
      longDescription = ''
        Tools to easily check and analyse Kodi log file.
      '';
      platform = platforms.all;
    };
  });
  metadata-common-musicbrainz-org = mkKodiPlugin {
    plugin = "metadata-common-musicbrainz-org";
    namespace = "metadata.common.musicbrainz.org";
    version = "2.2.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.musicbrainz.org/metadata.common.musicbrainz.org-2.2.4.zip";
      sha256 = "19jwz7ii2k2n6j24dishn2bpy0fani661wfxjnliz6yj8wx6rp1d";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: MusicBrainz Scraper Library";
      longDescription = ''
        Download Music information from www.musicbrainz.org
      '';
      platform = platforms.all;
    };
  };
  metadata-artists-universal = mkKodiPlugin {
    plugin = "metadata-artists-universal";
    namespace = "metadata.artists.universal";
    version = "4.3.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.artists.universal/metadata.artists.universal-4.3.3.zip";
      sha256 = "094p8yfwjac31kv4y3q9bjjfgz6vn363vda3bwwx2qjf5mvphb6z";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-allmusic-com # version 3.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-musicbrainz-org # version 2.1.0
      metadata-common-theaudiodb-com # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Universal Artist Scraper";
      longDescription = ''
        This scraper collects information from the following supported sites: TheAudioDb.com, MusicBrainz, last.fm, and allmusic.com, while grabs artwork from: fanart.tv, htbackdrops.com, last.fm and allmusic.com. It can be set field by field that from which site you want that specific information.

        The initial search is always done on MusicBrainz. In case allmusic link is not added on the MusicBrainz site fields from allmusic.com cannot be fetched (very easy to add those missing links though).
      '';
      platform = platforms.all;
    };
  };
  metadata-common-allmusic-com = mkKodiPlugin {
    plugin = "metadata-common-allmusic-com";
    namespace = "metadata.common.allmusic.com";
    version = "3.2.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.allmusic.com/metadata.common.allmusic.com-3.2.2.zip";
      sha256 = "1ihxh9xh0fs1nncqxpm4gzgkswxvgnxnfrxzvwkbxjsmvlqhjwhr";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: AllMusic Scraper Library";
      longDescription = ''
        Download Music information from www.allmusic.com
      '';
      platform = platforms.all;
    };
  };
  script-module-qrcode = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-qrcode";
    namespace = "script.module.qrcode";
    version = "6.1.0+matrix.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.qrcode/script.module.qrcode-6.1.0+matrix.3.zip";
      sha256 = "0v6wh0incgh8f57sy0l06xxbrr6jnpg2jxdw1v6hfad7g2fipvcw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.14.0+matrix.1
      script-module-pil # version 1.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: qrcode";
      longDescription = ''
        This module uses image libraries, Python Imaging Library (PIL) by default, to generate QR Codes.
      '';
      homepage = "https://pypi.org/project/qrcode/";
      platform = platforms.all;
    };
  });
  context-trakt-contextmenu = mkKodiPlugin {
    plugin = "context-trakt-contextmenu";
    namespace = "context.trakt.contextmenu";
    version = "1.1.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/context.trakt.contextmenu/context.trakt.contextmenu-1.1.0+matrix.1.zip";
      sha256 = "0rw9kfa28fgkaxz66sdnpqvb0w1l9civc0jy5rhkkwjj62w0gmgz";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-trakt # version 3.0.2
    ];
    meta = with lib; {
      description = "Kodi addon: Trakt - Contextmenu";
      longDescription = ''
        Add Trakt contextmenu button to context menu in library. This contextmenu will offer "Add to watchlist", "Rate this movie", "Toggle watched" and "Synchronize library".
      '';
      platform = platforms.all;
    };
  };
  metadata-tvdb-com-python = mkKodiPlugin {
    plugin = "metadata-tvdb-com-python";
    namespace = "metadata.tvdb.com.python";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.tvdb.com.python/metadata.tvdb.com.python-1.0.0.zip";
      sha256 = "0sfhszbgn9yz93smccy755a04ni0bk6s360vkdhca1rl31vi95bg";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      xbmc-python # version 3.0.0
      script-module-tvdbsimple # version 1.0.6
      script-module-trakt # version 3.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: The TVDB (new)";
      longDescription = ''
        TheTVDB.com is a TV Scraper. The site is a massive open database that can be modified by anybody and contains full meta data for many shows in different languages. All content and images on the site have been contributed by their users for users and have a high standard or quality. The database schema and website are open source under the GPL.
      '';
      platform = platforms.all;
    };
  };
  weather-multi = mkKodiPlugin {
    plugin = "weather-multi";
    namespace = "weather.multi";
    version = "0.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/weather.multi/weather.multi-0.0.5.zip";
      sha256 = "1n6bjbqdcr3s8i395sjzn8fkzh5r9xix0hldzk2l8l32975wzlzq";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-openweathermap-maps # version 1.0.4
      script-module-requests # version 2.22.0+matrix.1
      script-module-dateutil # version 2.8.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Multi Weather";
      longDescription = ''
        Weather forecast provided by Yahoo, Weatherbit and Openweathermap
      '';
      platform = platforms.all;
    };
  };
  script-audio-profiles = mkKodiPlugin {
    plugin = "script-audio-profiles";
    namespace = "script.audio.profiles";
    version = "2.0.100";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.audio.profiles/script.audio.profiles-2.0.100.zip";
      sha256 = "1hf4gc1dbb9v41b5z9b13bp216flf8x2vca2bw2csba1w9s1knih";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
    ];
    meta = with lib; {
      description = "Kodi addon: Audio Profiles";
      longDescription = ''
        Save audio profile and easily switch between them.
      '';
      homepage = "https://kodi.wiki/view/Add-on:Audio_Profiles";
      platform = platforms.all;
    };
  };
  script-module-tvdbsimple = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-tvdbsimple";
    namespace = "script.module.tvdbsimple";
    version = "1.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.tvdbsimple/script.module.tvdbsimple-1.0.6.zip";
      sha256 = "0hkan758hmp8al7vl116czrhfqnq24fs3lm9960jv7c865wyq9vg";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.9.1
    ];
    meta = with lib; {
      description = "Kodi addon: tvdbsimple";
      longDescription = ''
        Helper module for thetvdb site access
      '';
      platform = platforms.all;
    };
  });
  plugin-video-arloview = mkKodiPlugin {
    plugin = "plugin-video-arloview";
    namespace = "plugin.video.arloview";
    version = "1.1.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.arloview/plugin.video.arloview-1.1.1.zip";
      sha256 = "0g192z53ji1hq4fi53ga957xnh632s19vk3jm1kq358acva09vhn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-arlo # version 1.2.35
    ];
    meta = with lib; {
      description = "Kodi addon: Arlo Streamer";
      longDescription = ''
        List and stream each of your Arlo cameras in Kodi.  This plugin is compatible with Kodi v18 (Leia) and above.

            For questions/comments related to this plugin, contact JavaWiz1@hotmail.com

            Python interface to Arlo cameras based on:
            (https://github.com/jeffreydwalter/arlo) thanks jeffreydwalter!
      '';
      platform = platforms.all;
    };
  };
  script-module-tmdbsimple = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-tmdbsimple";
    namespace = "script.module.tmdbsimple";
    version = "2.2.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.tmdbsimple/script.module.tmdbsimple-2.2.0+matrix.1.zip";
      sha256 = "02ikazh5nmhi7x3prwjgdb5qrdfkfmmqzjpz1q6q2wgamvm0bz6c";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.15.1
    ];
    meta = with lib; {
      description = "Kodi addon: tmdbsimple";
      longDescription = ''
        Packed for Kodi from https://github.com/celiao/tmdbsimple
      '';
      homepage = "https://github.com/rmrector/script.module.tmdbsimple";
      platform = platforms.all;
    };
  });
  script-embuary-helper = mkKodiPlugin {
    plugin = "script-embuary-helper";
    namespace = "script.embuary.helper";
    version = "2.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.embuary.helper/script.embuary.helper-2.0.6.zip";
      sha256 = "1613g81wrc3kiz1dq9y7a8qvz0l2kwph8cinrg2zmn262n2dg4h8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pil # version 1.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: Embuary Helper";
      longDescription = ''
        Helper script to provide features and functions to the Embuary skin. A full documentation can be found on GitHub: https://github.com/sualfred/script.embuary.helper/wiki
      '';
      platform = platforms.all;
    };
  };
  script-module-arlo = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-arlo";
    namespace = "script.module.arlo";
    version = "1.2.35+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.arlo/script.module.arlo-1.2.35+matrix.1.zip";
      sha256 = "0jf28drx5zb26ppc0ay1q1mxjc5lg3lzp8dniza7n5lsvjr5rza6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-monotonic # version 1.5.0+matrix.1
      script-module-pysocks # version 1.7.0+matrix.1
      script-module-requests # version 2.22.0+matrix.1
      script-module-sseclient # version 0.0.24+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: arlo";
      longDescription = ''
        Packed for KODI from https://github.com/jeffreydwalter/arlo
      '';
      homepage = "https://github.com/jeffreydwalter/arlo";
      platform = platforms.all;
    };
  });
  script-kodi-loguploader = mkKodiPlugin {
    plugin = "script-kodi-loguploader";
    namespace = "script.kodi.loguploader";
    version = "1.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.kodi.loguploader/script.kodi.loguploader-1.0.3.zip";
      sha256 = "133qmcjm9mz8wl1sp5mmvp2w8nm2xvsaaa9wnb4r3l2f18yqv11x";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pyqrcode # version 1.2.1+matrix.1
      script-module-requests # version 2.22.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Kodi Logfile Uploader";
      longDescription = ''
        Uploads your kodi.log file and returns an url you can post on http://forum.kodi.tv/
      '';
      platform = platforms.all;
    };
  };
  service-librarywatchdog = mkKodiPlugin {
    plugin = "service-librarywatchdog";
    namespace = "service.librarywatchdog";
    version = "1.1.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.librarywatchdog/service.librarywatchdog-1.1.1.zip";
      sha256 = "1dhanrfwhlpp11z5lx4b6gi5hxshc6lqsmzask7ladh5c83mw61a";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-watchdog # version 0.10.2
    ];
    meta = with lib; {
      description = "Kodi addon: Library Watchdog";
      longDescription = ''
        Library Watchdog will watch your media sources for changes and automatically update the library when new files are added or removed. Update is instant.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-phoenixmediathek = mkKodiPlugin {
    plugin = "plugin-video-phoenixmediathek";
    namespace = "plugin.video.phoenixmediathek";
    version = "3.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.phoenixmediathek/plugin.video.phoenixmediathek-3.0.0.zip";
      sha256 = "06bqhq3ay1sj8ricl8jh6pf00lqlpvc914744swrlry57f4c91jk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: Phoenix Mediathek";
      longDescription = ''
        This video add-on provides access to videos of the German broadcaster Phoenix.
      '';
      homepage = "https://www.phoenix.de/";
      platform = platforms.all;
    };
  };
  plugin-audio-wdrrockpalast = mkKodiPlugin {
    plugin = "plugin-audio-wdrrockpalast";
    namespace = "plugin.audio.wdrrockpalast";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.audio.wdrrockpalast/plugin.audio.wdrrockpalast-2.0.0.zip";
      sha256 = "1kqk0fvj26g9cb1c8rdxjf0yrrimgpradcp6ls0mwi51xzcpnzy1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libwdr # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: WDR Rockpalast";
      longDescription = ''
        This is a music add-on for the WDR Rockpalast. The content may be geolocked.
      '';
      homepage = "https://www1.wdr.de/fernsehen/rockpalast/startseite/index.html";
      platform = platforms.all;
    };
  };
  plugin-video-wdrmaus = mkKodiPlugin {
    plugin = "plugin-video-wdrmaus";
    namespace = "plugin.video.wdrmaus";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.wdrmaus/plugin.video.wdrmaus-2.0.0.zip";
      sha256 = "0sfz8046ml0rqwngfgnwifrzkhh1hl83c35i7nknazxcl0w5gsk4";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.19.1
      script-module-libwdr # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: WDR Maus";
      longDescription = ''
        This add-on lists the videos of the WDR Maus website. Videos may be geolocked.
      '';
      homepage = "https://www.wdrmaus.de/";
      platform = platforms.all;
    };
  };
  plugin-video-zdftivi = mkKodiPlugin {
    plugin = "plugin-video-zdftivi";
    namespace = "plugin.video.zdftivi";
    version = "5.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.zdftivi/plugin.video.zdftivi-5.0.0.zip";
      sha256 = "0fr2nqhh3aylk1vbfcc7f58x1dagiklijw7x545ypmzj7yxn6lvv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libzdf # version 5.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: ZDF Tivi";
      longDescription = ''
        Videos on demand for children from the ZDF Mediathek.
      '';
      homepage = "https://www.zdf.de/";
      platform = platforms.all;
    };
  };
  script-module-libard = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-libard";
    namespace = "script.module.libard";
    version = "6.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.libard/script.module.libard-6.0.0.zip";
      sha256 = "00dp8c932ys9b38rhgcyvmbi7xi10kx09h8nr201x86q979l5bdy";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: libard";
      longDescription = ''
        This is a scraper for http://www.ardmediathek.de/.
      '';
      platform = platforms.all;
    };
  });
  script-module-libbr = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-libbr";
    namespace = "script.module.libbr";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.libbr/script.module.libbr-2.0.0.zip";
      sha256 = "0c17p5ai4k2isc0vfddsapzjybacq7ac5kjv16y3fwwy5fgarf4x";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: libbr";
      longDescription = ''
        This is a scraper for the BR Mediathek (http://www.br.de/mediathek/video/index.html).
      '';
      platform = platforms.all;
    };
  });
  script-module-libwdr = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-libwdr";
    namespace = "script.module.libwdr";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.libwdr/script.module.libwdr-2.0.0.zip";
      sha256 = "02hm5xhhynwcx870dfklc46xklna34lyid9p80h994iwl5m55pf3";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-libmediathek4 # version 1.0.0
      script-module-requests # version 2.19.1
    ];
    meta = with lib; {
      description = "Kodi addon: libwdr";
      longDescription = ''
        This is a scraper for content of the German broadcaster "WDR".
      '';
      platform = platforms.all;
    };
  });
  script-module-watchdog = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-watchdog";
    namespace = "script.module.watchdog";
    version = "0.10.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.watchdog/script.module.watchdog-0.10.2+matrix.1.zip";
      sha256 = "1dyiklb8lnaq6660bzqqvzrj7xmybv40ga75yjlnhwb69fyk0f7l";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pathtools # version 0.1.2+matrix.2
    ];
    meta = with lib; {
      description = "Kodi addon: watchdog";
      longDescription = ''
        Python API and shell utilities to monitor file system events.
      '';
      homepage = "https://pypi.org/project/watchdog";
      platform = platforms.all;
    };
  });
  script-module-libmediathek4 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-libmediathek4";
    namespace = "script.module.libmediathek4";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.libmediathek4/script.module.libmediathek4-1.0.0.zip";
      sha256 = "0bf6k9mgh13mxq1v8f8v3yk5w5zmar9yz5wlxcfcmgin66zyfh4l";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: libmediathek4";
      longDescription = ''
        This lib is a mini framework. It is used in my (sarbes) "Mediathek" scrapers.
      '';
      platform = platforms.all;
    };
  });
  script-module-pathtools = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pathtools";
    namespace = "script.module.pathtools";
    version = "0.1.2+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pathtools/script.module.pathtools-0.1.2+matrix.2.zip";
      sha256 = "01vf7r2f1q34dq7gx1zsh3qq83zvdbqhpj7q8hr6gk9xixfdq3pv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pathtools";
      longDescription = ''
        Pattern matching and various utilities for file systems paths.
      '';
      homepage = "https://pypi.org/project/pathtools";
      platform = platforms.all;
    };
  });
  script-module-blinker = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-blinker";
    namespace = "script.module.blinker";
    version = "1.4.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.blinker/script.module.blinker-1.4.0+matrix.2.zip";
      sha256 = "01b8ss1gbgnfs81rpxd8q50hb9y4apzi81qil75cwvbbivb3hcml";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: blinker";
      longDescription = ''
        Blinker provides a fast dispatching system that allows any number of interested parties to subscribe to events, or signals
      '';
      homepage = "https://pythonhosted.org/blinker/";
      platform = platforms.all;
    };
  });
  script-module-iso8601 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-iso8601";
    namespace = "script.module.iso8601";
    version = "0.1.12+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.iso8601/script.module.iso8601-0.1.12+matrix.2.zip";
      sha256 = "098nlq4ghzim3kp17grh1zcfvd0nrvfkccx1vg8z85vbi5a70bcl";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: iso8601";
      longDescription = ''
        This module parses the most common forms of ISO 8601 date strings (e.g. 2007-01-14T20:34:22+00:00) into datetime objects.
      '';
      homepage = "https://pypi.org/project/iso8601/";
      platform = platforms.all;
    };
  });
  script-module-chardet = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-chardet";
    namespace = "script.module.chardet";
    version = "3.0.4+matrix.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.chardet/script.module.chardet-3.0.4+matrix.3.zip";
      sha256 = "05928dj4fsj2zg8ajdial3sdf8izddq64sr0al3zy1gqw91jp80f";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: chardet";
      longDescription = ''
        Packed for Kodi from https://github.com/chardet/chardet
      '';
      homepage = "https://chardet.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  script-module-pyserial = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyserial";
    namespace = "script.module.pyserial";
    version = "3.4.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyserial/script.module.pyserial-3.4.0+matrix.2.zip";
      sha256 = "13y8v1cswrz4nlfbmbwkqw56fdlkqzxp4jkbvh86jfmy54684m2q";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pyserial";
      longDescription = ''
        Packed for KODI from https://github.com/pyserial/pyserial
      '';
      homepage = "https://github.com/pyserial/pyserial";
      platform = platforms.all;
    };
  });
  script-module-simpleeval = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-simpleeval";
    namespace = "script.module.simpleeval";
    version = "0.9.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.simpleeval/script.module.simpleeval-0.9.10.zip";
      sha256 = "1a367wnszcak2nh19pnc3jivb63inrwsbbfwpy3i2gxdii4i5czd";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Simple Eval";
      longDescription = ''
        A library for easily adding evaluatable expressions into python projects
      '';
      platform = platforms.all;
    };
  });
  service-autosubs = mkKodiPlugin {
    plugin = "service-autosubs";
    namespace = "service.autosubs";
    version = "1.1.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.autosubs/service.autosubs-1.1.1.zip";
      sha256 = "1n1bvndiwa090qfm9rwiw155w9x2xcah1gv8jq1bs99i65wmqci0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: AutoSubs";
      longDescription = ''
        Auto Search for Subtitles on Playback start if no subs are found.[CR][CR]Icon credits goes to zNET Computer Solutions http://www.znetcs.pl
      '';
      platform = platforms.all;
    };
  };
  metadata-common-fanart-tv = mkKodiPlugin {
    plugin = "metadata-common-fanart-tv";
    namespace = "metadata.common.fanart.tv";
    version = "3.6.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.fanart.tv/metadata.common.fanart.tv-3.6.3.zip";
      sha256 = "0v9nqlk2jydqlc1avybh8jl42w43ymyqn7pwj27rbiqc6xz6fia0";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: fanart.tv Scraper Library";
      longDescription = ''
        Download backdrops from www.fanart.tv.com
      '';
      platform = platforms.all;
    };
  };
  script-skinvariables = mkKodiPlugin {
    plugin = "script-skinvariables";
    namespace = "script.skinvariables";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.skinvariables/script.skinvariables-0.0.3.zip";
      sha256 = "13ja1n803nkpgkqp4ipiygln4jryckfrydxdv9p40qxa0sd838j8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Variables";
      longDescription = ''
        Skin Variables helps skinners to construct variables for multiple containers and listitems from a template
      '';
      platform = platforms.all;
    };
  };
  script-skin-helper-colorpicker = mkKodiPlugin {
    plugin = "script-skin-helper-colorpicker";
    namespace = "script.skin.helper.colorpicker";
    version = "2.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.skin.helper.colorpicker/script.skin.helper.colorpicker-2.0.1.zip";
      sha256 = "1qj5hp1khvvzrb6f13wapffa24r4z5vwf35gbqv51xdf06w7hha8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pil # version 1.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Helper Service ColorPicker";
      longDescription = ''
        Colorpicker for Kodi Skins. Part of Skin Helper Suite
      '';
      platform = platforms.all;
    };
  };
  script-speedfaninfo = mkKodiPlugin {
    plugin = "script-speedfaninfo";
    namespace = "script.speedfaninfo";
    version = "1.1.101";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.speedfaninfo/script.speedfaninfo-1.1.101.zip";
      sha256 = "158fprg9h9xdj9ds7fnmbb76zvzw2032hr9jvq0wj2rzd48ivhzv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-kodi-six # version 0.1.3.1
    ];
    meta = with lib; {
      description = "Kodi addon: SpeedFan Information Display";
      longDescription = ''
        Parses and displays information from the SpeedFan log. While this plugin works on any platform, SpeedFan only works on Windows, so it is optimally built for people using Kodi on Windows. Please see readme.txt for information on how to configure your SpeedFan log so that the plugin can parse it properly.
      '';
      homepage = "https://kodi.wiki/view/Add-on:SpeedFan_Information_Display";
      platform = platforms.all;
    };
  };
  plugin-video-themoviedb-helper = mkKodiPlugin {
    plugin = "plugin-video-themoviedb-helper";
    namespace = "plugin.video.themoviedb.helper";
    version = "2.4.36";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.themoviedb.helper/plugin.video.themoviedb.helper-2.4.36.zip";
      sha256 = "0xqzh3pcxyqpgxw6p5lnik3879v2nhx3af9msfqcqkqc5chb14mi";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-simplecache # version 1.0.11
      script-module-requests # version 2.9.1
      script-module-pil # version 1.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: TheMovieDb Helper";
      longDescription = ''
        TheMovieDb Helper provides details about movies, tvshows and actors from TMDb. Users can access a variety of lists from TMDb and Trakt.
      '';
      platform = platforms.all;
    };
  };
  plugin-video-sms = mkKodiPlugin {
    plugin = "plugin-video-sms";
    namespace = "plugin.video.sms";
    version = "0.1.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.sms/plugin.video.sms-0.1.0.zip";
      sha256 = "1l7s90cjg9q9b8y37b0zl77nvrfmq03i92q69hsmbfsbwi6ji2xf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0
      script-module-bottle # version 0.12.18
    ];
    meta = with lib; {
      description = "Kodi addon: Scoot Media Streamer";
      longDescription = ''
        Scoot Media Streamer allows you to stream media from any SMS Server available on the internet. If you have a media server at home with SMS Server installed you can stream your media anywhere to a number of devices. This is the official Kodi addon which allows you to stream media from your SMS Server to any Kodi compatable device.
      '';
      homepage = "https://github.com/scoot-software";
      platform = platforms.all;
    };
  };
  script-module-pyamf = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyamf";
    namespace = "script.module.pyamf";
    version = "0.8.10+matrix.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyamf/script.module.pyamf-0.8.10+matrix.3.zip";
      sha256 = "17v43m2533kf39n0inafcjxmdp7f9j6gb0ns6iynlklkil73lp78";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-defusedxml # version 0.6.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: PyAMF";
      longDescription = ''
        The Adobe Integrated Runtime and Adobe Flash Player use AMF to communicate between an application and a remote server. AMF encodes remote procedure calls (RPC) into a compact binary representation that can be transferred over HTTP/HTTPS or the RTMP/RTMPS protocol. Objects and data values are serialized into this binary format, which increases performance, allowing applications to load data up to 10 times faster than with text-based formats such as XML or SOAP.
        AMF3, the default serialization for ActionScript 3.0, provides various advantages over AMF0, which is used for ActionScript 1.0 and 2.0. AMF3 sends data over the network more efficiently than AMF0. AMF3 supports sending int and uint objects as integers and supports data types that are available only in ActionScript 3.0, such as ByteArray, ArrayCollection, ObjectProxy and IExternalizable.
      '';
      homepage = "https://pypi.org/project/Py3AMF/";
      platform = platforms.all;
    };
  });
  script-favourites = mkKodiPlugin {
    plugin = "script-favourites";
    namespace = "script.favourites";
    version = "8.1.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.favourites/script.favourites-8.1.1.zip";
      sha256 = "0xy0z4p83h4q392f3qssqa16m2nm8mmx8xjxi8dvjfw5kjs2cfa7";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Favourites script";
      longDescription = ''
        Fetches item from your Kodi favourites to populate Home menu/submenu with custom buttons.
      '';
      platform = platforms.all;
    };
  };
  script-openweathermap-maps = mkKodiPlugin {
    plugin = "script-openweathermap-maps";
    namespace = "script.openweathermap.maps";
    version = "1.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.openweathermap.maps/script.openweathermap.maps-1.0.5.zip";
      sha256 = "1i3fziqzkpmxp0qb0ljhvgghv0yqxxhszkhkrrpc3kk2k6pzlm9y";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pil # version 1.1.7
      script-module-requests # version 2.22.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: OpenWeatherMap Maps";
      longDescription = ''
        Weather maps provided by OpenWeatherMap (http://openweathermap.org/)
      '';
      homepage = "https://forum.kodi.tv/showthread.php?tid=207110";
      platform = platforms.all;
    };
  };
  service-subtitles-shooter = mkKodiPlugin {
    plugin = "service-subtitles-shooter";
    namespace = "service.subtitles.shooter";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.shooter/service.subtitles.shooter-2.0.0.zip";
      sha256 = "1fjr9wq09mg0drnxf902v0j8m09nl1wbjkilmcmsnazr7d5dk547";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-chardet # version 3.0.4
      script-module-beautifulsoup4 # version 4.6.2
    ];
    meta = with lib; {
      description = "Kodi addon: Shooter";
      longDescription = ''
        Shooter subtitle service
      '';
      platform = platforms.all;
    };
  };
  script-playalbum = mkKodiPlugin {
    plugin = "script-playalbum";
    namespace = "script.playalbum";
    version = "4.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.playalbum/script.playalbum-4.0.2.zip";
      sha256 = "1w0pkgaggxp8f0001k0v49kdr569xya4y0lcln76pn2raq0aqzfa";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Play Album Script";
      longDescription = ''
        Script will play a full album when executed in the album info dialog.
      '';
      platform = platforms.all;
    };
  };
  script-image-resource-select = mkKodiPlugin {
    plugin = "script-image-resource-select";
    namespace = "script.image.resource.select";
    version = "3.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.image.resource.select/script.image.resource.select-3.0.2.zip";
      sha256 = "0lj9mixxd1n85dxxaa1kcdxy778mrz6a0b9vp0g0cn61bhc1nkn1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Image Resource Select Addon";
      longDescription = ''
        Script for skinners to let users select an image resource addon.
      '';
      platform = platforms.all;
    };
  };
  skin-quartz = mkKodiPlugin {
    plugin = "skin-quartz";
    namespace = "skin.quartz";
    version = "5.19.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/skin.quartz/skin.quartz-5.19.0.zip";
      sha256 = "1z82v4jp1niv4qx42wvkmdpz8m8r1rvskmz8fw6rcnmws1xk2dwc";
    };
    propagatedBuildInputs = [
      xbmc-gui # version 5.15.0
      script-favourites # version 4.0.4
    ];
    meta = with lib; {
      description = "Kodi addon: Quartz";
      longDescription = ''
        Quartz is a light-weight skin with a intuitive user interface and highly customizable home screen.
      '';
      platform = platforms.all;
    };
  };
  service-scrobbler-librefm = mkKodiPlugin {
    plugin = "service-scrobbler-librefm";
    namespace = "service.scrobbler.librefm";
    version = "4.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.scrobbler.librefm/service.scrobbler.librefm-4.0.4.zip";
      sha256 = "1v1yv5b75xvbgz5can2mnjnd4ccwvfv4bpx6bdqzx40j72z4pkqk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Libre.fm Scrobbler";
      longDescription = ''
        Scrobbler will submit info of the songs you've been listening to in Kodi to libre.fm
      '';
      platform = platforms.all;
    };
  };
  script-module-oauthlib = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-oauthlib";
    namespace = "script.module.oauthlib";
    version = "3.1.0+matrix.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.oauthlib/script.module.oauthlib-3.1.0+matrix.3.zip";
      sha256 = "0zni3ylzqransmlb2hxf0njikvvq5n39292df892ayww0yakhxx6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-blinker # version 1.4.0+matrix.1
      script-module-pyjwt # version 1.7.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: oauthlib";
      longDescription = ''
        A generic, spec-compliant, thorough implementation of the OAuth request-signing logic
      '';
      homepage = "https://pypi.python.org/pypi/oauthlib";
      platform = platforms.all;
    };
  });
  script-module-pymysql = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pymysql";
    namespace = "script.module.pymysql";
    version = "0.9.3+matrix.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pymysql/script.module.pymysql-0.9.3+matrix.3.zip";
      sha256 = "1v4zg5nfmwwhqb3f69l4ia66di4la58lapmf56bc9c2jyja80fqh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pymysql";
      longDescription = ''
        Simple MySql Connector for Python. Package by smitchell6879
      '';
      homepage = "https://pymysql.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  plugin-video-vimcasts = mkKodiPlugin {
    plugin = "plugin-video-vimcasts";
    namespace = "plugin.video.vimcasts";
    version = "1.3.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.vimcasts/plugin.video.vimcasts-1.3.0+matrix.1.zip";
      sha256 = "0lmjnf5bfq5yc0398r1wrjfwbnffaffyiiz4gpsj0m7kf6zargr1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-xbmcswift2 # version 19.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: VimCasts";
      longDescription = ''
        Vimcasts publishes free screencasts about Vim, the text editor. Vim has been around in one form or another for over 20 years. The learning curve is famously difficult, but those who manage to climb it insist that nothing can match Vim's modal editing model for speed and efficiency.[CR][CR]The patterns of use that make a Vim master productive are not easily discovered. Trial and error will get you so far, but the best way to learn is to watch an experienced Vim user at work. By providing short videos with digestible advice, Vimcasts gives you something you can take away and use immediately to improve your productivity. Vimcasts aims to be the expert Vim colleague you never had.[CR][CR]Vimcasts is produced by Drew Neil (aka nelstrom), who came to Vim from TextMate. He made the switch when starting work at a company that uses Linux workstations. His choice of text editor was influenced by colleagues.
      '';
      platform = platforms.all;
    };
  };
  plugin-image-bancasapo = mkKodiPlugin {
    plugin = "plugin-image-bancasapo";
    namespace = "plugin.image.bancasapo";
    version = "3.0.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.image.bancasapo/plugin.image.bancasapo-3.0.1+matrix.1.zip";
      sha256 = "074ydp1spp6rp92dj4sm7z66hqgxsc4xfl97f3jafrbkapf0d4ki";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-routing # version 0.2.0
      script-module-requests # version 2.22.0
    ];
    meta = with lib; {
      description = "Kodi addon: Banca Sapo";
      longDescription = ''
        A Kodi image plugin for Banca Sapo
      '';
      homepage = "https://24.sapo.pt/jornais";
      platform = platforms.all;
    };
  };
  service-subtitles-legendasdivx = mkKodiPlugin {
    plugin = "service-subtitles-legendasdivx";
    namespace = "service.subtitles.legendasdivx";
    version = "1.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.legendasdivx/service.subtitles.legendasdivx-1.0.4.zip";
      sha256 = "0fh5sn7gyqfsx89a7lyp56ilr4gd2h65b2ad4plj3224gwdnkyv3";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      vfs-rar # version 3.3.0
    ];
    meta = with lib; {
      description = "Kodi addon: LegendasDivx.com";
      longDescription = ''
        Search and download subtitles from LegendasDivx.com. Please check the add-on configuration before using it! Note: The "Force Full Description" switch will grab all the text in the website including all the non useful information. The "Parent Folder Search and Match" set to "AUTO" will first search by parent folder but if it's not a release then it will search normally, it's recommend to leave it "AUTO". Library is always primary this is only for non Library Movies\TVSHOWS.
      '';
      homepage = "https://www.legendasdivx.pt";
      platform = platforms.all;
    };
  };
  script-module-livestreamer = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-livestreamer";
    namespace = "script.module.livestreamer";
    version = "1.12.2+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.livestreamer/script.module.livestreamer-1.12.2+matrix.2.zip";
      sha256 = "17r4hya0amchb66mp47ks959zdzxy9rlnvpld0f9pk1izh0j3xaq";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: livestreamer";
      longDescription = ''
        Livestreamer is a command-line utility that pipes video streams from various services into a video player, such as VLC. The main purpose of Livestreamer is to allow the user to avoid buggy and CPU heavy flash plugins but still be able to enjoy various streamed content. There is also an API available for developers who want access to the video stream data.
      '';
      homepage = "http://docs.livestreamer.io";
      platform = platforms.all;
    };
  });
  script-module-feedparser = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-feedparser";
    namespace = "script.module.feedparser";
    version = "6.0.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.feedparser/script.module.feedparser-6.0.0+matrix.2.zip";
      sha256 = "0aykmbxq19nwc6j7hvj3ckrdl8v7n9h1iravfc9hgk13f226w5y6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-sgmllib3k # version 1.0.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: feedparser";
      longDescription = ''
        Universal feed parser, handles RSS 0.9x, RSS 1.0, RSS 2.0, CDF, Atom 0.3, and Atom 1.0 feeds
      '';
      platform = platforms.all;
    };
  });
  script-module-html2text = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-html2text";
    namespace = "script.module.html2text";
    version = "2020.1.16+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.html2text/script.module.html2text-2020.1.16+matrix.2.zip";
      sha256 = "06gmpv52anhcmnlg9vzd0f2z101fn2360dlkgsmqkz2ywvzdl5qw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: html2text";
      longDescription = ''
        html2text is a Python script that converts a page of HTML into clean, easy-to-read plain ASCII text. Better yet, that ASCII also happens to be valid Markdown (a text-to-HTML format).
      '';
      homepage = "http://alir3z4.github.io/html2text/";
      platform = platforms.all;
    };
  });
  script-module-m3u8 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-m3u8";
    namespace = "script.module.m3u8";
    version = "0.5.4+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.m3u8/script.module.m3u8-0.5.4+matrix.2.zip";
      sha256 = "1cg0kyljxgh9fpb5j78zzyy1ssmg2rczpdxksc0d6y9r65l1apm1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-iso8601 # version 0.1.12+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: m3u8";
      longDescription = ''
        Packed for XBMC from https://github.com/globocom/m3u8
      '';
      homepage = "https://pypi.org/project/m3u8/";
      platform = platforms.all;
    };
  });
  script-module-webencodings = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-webencodings";
    namespace = "script.module.webencodings";
    version = "0.5.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.webencodings/script.module.webencodings-0.5.1+matrix.2.zip";
      sha256 = "1hp1skrbnwz945x1mr1zzqpkkd6mgvr5rin8d90sp7l4dl3yvawp";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: webencodings";
      longDescription = ''
        This module has encoding labels and BOM detection, but the actual implementation for encoders and decoders is Python’s.
      '';
      homepage = "https://pythonhosted.org/webencodings/";
      platform = platforms.all;
    };
  });
  script-module-xmltodict = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-xmltodict";
    namespace = "script.module.xmltodict";
    version = "0.12.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.xmltodict/script.module.xmltodict-0.12.0+matrix.2.zip";
      sha256 = "0g2gsrph63dnvf6dg83dklwba8a01pzhqg7vw56p8c0ixd0a83ly";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: xmltodict";
      longDescription = ''
        xmltodict is a Python module that makes working with XML feel like you are working with JSON, as in this "spec".
      '';
      homepage = "https://github.com/martinblech/xmltodict";
      platform = platforms.all;
    };
  });
  script-module-yaml = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-yaml";
    namespace = "script.module.yaml";
    version = "5.3.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.yaml/script.module.yaml-5.3.0+matrix.2.zip";
      sha256 = "0mprm5lyn1vff6i2vwphifiz7lhm2950x8d2vzkx79lqmrb2aarb";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: PyYAML";
      longDescription = ''
        A packaged version of files needed for the pyyamml library.
      '';
      homepage = "https://pyyaml.org";
      platform = platforms.all;
    };
  });
  script-module-unidecode = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-unidecode";
    namespace = "script.module.unidecode";
    version = "1.1.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.unidecode/script.module.unidecode-1.1.1+matrix.2.zip";
      sha256 = "0vzdxdrpc8acvz6imma6lvp43wmvdj724vjx7zy26xq9846h3xf2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: unidecode";
      longDescription = ''
        ASCII transliterations of Unicode text by Sean M. Burke and Tomaz Solc
      '';
      homepage = "https://pypi.org/project/Unidecode";
      platform = platforms.all;
    };
  });
  script-module-uritemplate = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-uritemplate";
    namespace = "script.module.uritemplate";
    version = "3.0.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.uritemplate/script.module.uritemplate-3.0.1+matrix.2.zip";
      sha256 = "0fa02hw6jkgsdlr7kwcrbnb863i103p3sr7r8xf0lkv8a3s0fk76";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: uritemplate";
      longDescription = ''
        A packaged version of the uritemplates python module.
      '';
      homepage = "https://github.com/python-hyper/uritemplate";
      platform = platforms.all;
    };
  });
  service-subtitles-napisy24pl = mkKodiPlugin {
    plugin = "service-subtitles-napisy24pl";
    namespace = "service.subtitles.napisy24pl";
    version = "3.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/service.subtitles.napisy24pl/service.subtitles.napisy24pl-3.0.1.zip";
      sha256 = "09mhcby0k4pi3ii7nz5ybllvzkm4d4lrxqj9vqr78q3vx9g5dylf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-beautifulsoup4 # version 4.6.2
    ];
    meta = with lib; {
      description = "Kodi addon: Napisy24.pl";
      longDescription = ''
        Search and Download subtitles from napisy24.pl.
      '';
      platform = platforms.all;
    };
  };
  script-module-twitter = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-twitter";
    namespace = "script.module.twitter";
    version = "1.18.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.twitter/script.module.twitter-1.18.0+matrix.2.zip";
      sha256 = "1s0iywklh0m91whlzr2k7j6x76y1ai29czcc1z57gigg8cdr5i16";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Twitter";
      longDescription = ''
        An API and command-line toolset for Twitter (twitter.com)
      '';
      homepage = "https://mike.verdone.ca/twitter";
      platform = platforms.all;
    };
  });
  script-module-simplejson = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-simplejson";
    namespace = "script.module.simplejson";
    version = "3.17.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.simplejson/script.module.simplejson-3.17.0+matrix.2.zip";
      sha256 = "12s0hrkjb59wxp31a550jpmb1bznl3s0axd8b9q23p5b9b3kicaw";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: simplejson";
      longDescription = ''
        Simple, fast, extensible JSON encoder/decoder for Python
      '';
      homepage = "https://pypi.org/project/simplejson/";
      platform = platforms.all;
    };
  });
  script-module-six = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-six";
    namespace = "script.module.six";
    version = "1.14.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.six/script.module.six-1.14.0+matrix.2.zip";
      sha256 = "1f9g43j4y5x7b1bgbwqqfj0p2bkqjpycj17dj7a9j271mcr5zhwb";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: six";
      longDescription = ''
        Six is a Python 2 and 3 compatibility library. It provides utility functions for smoothing over the differences between the Python versions with the goal of writing Python code that is compatible on both Python versions. See the documentation for more information on what is provided.
      '';
      homepage = "https://pypi.org/project/six/";
      platform = platforms.all;
    };
  });
  script-module-pytz = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pytz";
    namespace = "script.module.pytz";
    version = "2019.3.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pytz/script.module.pytz-2019.3.0+matrix.2.zip";
      sha256 = "0q62ryfadg0q87m0dy945p4br1mafyxn0aib6l7rn60b2ni7fwgk";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pytz";
      longDescription = ''
        pytz brings the Olson tz database into Python. This library allows accurate and cross platform timezone calculations using Python 2.4 or higher. It also solves the issue of ambiguous times at the end of daylight saving time, which you can read more about in the Python Library Reference (datetime.tzinfo).
      '';
      homepage = "https://pythonhosted.org/pytz/";
      platform = platforms.all;
    };
  });
  script-module-requests-cache = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-requests-cache";
    namespace = "script.module.requests-cache";
    version = "0.5.2+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.requests-cache/script.module.requests-cache-0.5.2+matrix.2.zip";
      sha256 = "0fgl4jayq6hbhqxg16nfy9qizwf54c8nvg0icv93knaj13zfzkz8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: requests-cache";
      longDescription = ''
        Packed for KODI: requests-cache
      '';
      homepage = "https://pypi.org/project/requests-cache/";
      platform = platforms.all;
    };
  });
  script-module-requests_oauthlib = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-requests_oauthlib";
    namespace = "script.module.requests_oauthlib";
    version = "1.3.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.requests_oauthlib/script.module.requests_oauthlib-1.3.0+matrix.2.zip";
      sha256 = "04pg2ykr87zi5i6lzlw054g1fmyw3h1q9xbk6gj30x5vxld8f49g";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-oauthlib # version 3.1.0+matrix.1
      script-module-requests # version 2.22.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: requests_oauthlib";
      longDescription = ''
        This project provides first-class OAuth library support for Requests.
      '';
      homepage = "https://pypi.org/project/requests-oauthlib";
      platform = platforms.all;
    };
  });
  script-module-sgmllib3k = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-sgmllib3k";
    namespace = "script.module.sgmllib3k";
    version = "1.0.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.sgmllib3k/script.module.sgmllib3k-1.0.0+matrix.2.zip";
      sha256 = "19df9wzmj8fxbsdd8y8gv77i94rx63if2h1iikxmkhnp46cc5f0y";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: sgmllib3k";
      longDescription = ''
        Python 3 port of sgmllib
      '';
      platform = platforms.all;
    };
  });
  script-module-pyjwt = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyjwt";
    namespace = "script.module.pyjwt";
    version = "1.7.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyjwt/script.module.pyjwt-1.7.1+matrix.2.zip";
      sha256 = "01k2sxw6nbbbrcf6hxvy9rd5wnpx8hj7jcgvb1m57mssxyiq608b";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pyjwt";
      longDescription = ''
        pyjwt module
      '';
      homepage = "https://pyjwt.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  script-module-pylast = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pylast";
    namespace = "script.module.pylast";
    version = "3.2.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pylast/script.module.pylast-3.2.0+matrix.2.zip";
      sha256 = "0cv23g7s3lx3dldnj59agblkw88xfr37yz5225b9zdr7aw32c5ay";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pyLastFM";
      longDescription = ''
        A Python interface to Last.fm and Libre.fm
      '';
      homepage = "https://pypi.org/project/pylast/";
      platform = platforms.all;
    };
  });
  script-module-pyqrcode = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyqrcode";
    namespace = "script.module.pyqrcode";
    version = "1.2.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyqrcode/script.module.pyqrcode-1.2.1+matrix.2.zip";
      sha256 = "0l52rmpvfplp0p6yfp2x0czgvwx9mw54hc6q3h8wxmvp8gmyrci0";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: pyQRcode";
      longDescription = ''
        A Python interface to generate QR Code
      '';
      homepage = "https://pypi.org/project/PyQRCode";
      platform = platforms.all;
    };
  });
  script-module-oauth2client = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-oauth2client";
    namespace = "script.module.oauth2client";
    version = "4.1.3+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.oauth2client/script.module.oauth2client-4.1.3+matrix.2.zip";
      sha256 = "16fsri30j6k735z2wfhzrrlq24fc9xhqqjkcydxffw5h1y7djmnv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-httplib2 # version 0.17.0+matrix.1
      script-module-six # version 1.14.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: oauth2client";
      longDescription = ''
        oauth2client is a client library for OAuth 2.0.
      '';
      homepage = "https://oauth2client.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  script-module-httplib2 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-httplib2";
    namespace = "script.module.httplib2";
    version = "0.17.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.httplib2/script.module.httplib2-0.17.0+matrix.2.zip";
      sha256 = "07y19i0qv63p8xsi061z7x2zhnwszjpm01i1lfa25hicvzwwx54k";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: httplib2";
      longDescription = ''
        httplib2 module
      '';
      homepage = "https://pypi.python.org/pypi/httplib2";
      platform = platforms.all;
    };
  });
  script-module-mechanize = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-mechanize";
    namespace = "script.module.mechanize";
    version = "0.4.3+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.mechanize/script.module.mechanize-0.4.3+matrix.2.zip";
      sha256 = "0m8l3ijbxlppc34367pz0vzcbnnzynkf11g48b5qzc1qczb6lwd6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-html5lib # version 1.0.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Mechanize";
      longDescription = ''
        Stateful programmatic web browsing in Python, after Andy Lester’s Perl module WWW::Mechanize.
      '';
      homepage = "https://mechanize.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  script-module-oauth2 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-oauth2";
    namespace = "script.module.oauth2";
    version = "1.9.0+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.oauth2/script.module.oauth2-1.9.0+matrix.2.zip";
      sha256 = "0j25s7ibii810kv9c3dxs7gq12ji4h3k39cpbkxs9xbshndsqnby";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-httplib2 # version 0.17.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: oAuth2";
      longDescription = ''
        oAuth2 module
      '';
      homepage = "http://pypi.python.org/pypi/oauth2/";
      platform = platforms.all;
    };
  });
  script-module-html5lib = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-html5lib";
    namespace = "script.module.html5lib";
    version = "1.0.1+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.html5lib/script.module.html5lib-1.0.1+matrix.2.zip";
      sha256 = "0g49iqsvhmrg05kqvj6dyr1ar3br30dfpkil7y5rqn65vg07dz7x";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.14.0+matrix.1
      script-module-webencodings # version 0.5.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: html5lib-python";
      longDescription = ''
        html5lib is a pure-python library for parsing HTML. It is designed to conform to the WHATWG HTML specification, as is implemented by all major web browsers.
      '';
      homepage = "https://github.com/html5lib/html5lib-python";
      platform = platforms.all;
    };
  });
  script-module-bottle = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-bottle";
    namespace = "script.module.bottle";
    version = "0.12.18+matrix.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.bottle/script.module.bottle-0.12.18+matrix.2.zip";
      sha256 = "16x0kzdhjgim7k2qfk4sp9283i7gba9gnxjf0qvhjq1j3j7k65x8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Bottle";
      longDescription = ''
        Bottle is a fast and simple micro-framework for small web applications. It offers request dispatching (Routes) with url parameter support, templates, a built-in HTTP Server and adapters for many third party WSGI/HTTP-server and template engines - all in a single file and with no dependencies other than the Python Standard Library.
      '';
      homepage = "https://bottlepy.org/docs/dev/";
      platform = platforms.all;
    };
  });
  plugin-video-mms = mkKodiPlugin {
    plugin = "plugin-video-mms";
    namespace = "plugin.video.mms";
    version = "4.1.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.video.mms/plugin.video.mms-4.1.0.zip";
      sha256 = "1q9bacjnz9ps7vgrhjnif56xfxxx0g0q64ya0qx5p88dk775rxxj";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-routing # version 0.2.3+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Missing Movies";
      longDescription = ''
        Scans media sources for movies, TV shows and episodes that got missed during the library scan. This add-on can used to identify, play or manually add missing videos to your media library.
      '';
      platform = platforms.all;
    };
  };
  script-module-mutagen = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-mutagen";
    namespace = "script.module.mutagen";
    version = "1.44.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.mutagen/script.module.mutagen-1.44.0+matrix.1.zip";
      sha256 = "0x9cbfzcscb3zy0vg0p58ikv16m7pa3frzk0s2nyxm9x8nd20mah";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Mutagen";
      longDescription = ''
        Mutagen is a Python module to handle audio metadata.
      '';
      homepage = "https://mutagen.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  script-module-pyxbmct = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyxbmct";
    namespace = "script.module.pyxbmct";
    version = "1.3.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyxbmct/script.module.pyxbmct-1.3.1+matrix.1.zip";
      sha256 = "0sbhdrb1fzxcbjs38j1x2rlirm0rxiaag9icfx9gqm8fl2bc30mp";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version None
      script-module-kodi-six # version None
    ];
    meta = with lib; {
      description = "Kodi addon: PyXBMCt";
      longDescription = ''
        PyXBMCt is a mini-framework for simple XBMC addon UI buliding. It is similar to PyQt and provides parent windows, a number of UI controls (widgets) and a grid layout manager to place controls.
      '';
      homepage = "http://romanvm.github.io/script.module.pyxbmct/";
      platform = platforms.all;
    };
  });
  plugin-library-node-editor = mkKodiPlugin {
    plugin = "plugin-library-node-editor";
    namespace = "plugin.library.node.editor";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.library.node.editor/plugin.library.node.editor-2.0.0.zip";
      sha256 = "1x5xbk74qhk9mg79vjhhbpwsb1f84ggrlqv4iw6rqy0176ms2wsv";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-unidecode # version 1.1.1
    ];
    meta = with lib; {
      description = "Kodi addon: Library Node Editor";
      longDescription = ''
        Create and edit custom library nodes.
      '';
      platform = platforms.all;
    };
  };
  context-embuary-info = mkKodiPlugin {
    plugin = "context-embuary-info";
    namespace = "context.embuary.info";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/context.embuary.info/context.embuary.info-2.0.0.zip";
      sha256 = "1x12kibv30nm7xn2w2iwqzrbcgyykzmm5b0nr5krlayag2xrj2i8";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-embuary-info # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Embuary Info - Open dialog";
      longDescription = ''
        Open Embuary Info dialog from context menu. Needs script.embuary.info installed and activated. Available for movies, tv shows and actors.
      '';
      platform = platforms.all;
    };
  };
  script-module-routing = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-routing";
    namespace = "script.module.routing";
    version = "0.2.3+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.routing/script.module.routing-0.2.3+matrix.1.zip";
      sha256 = "1qhp40xd8mbcvzwlamqw1j5l224ry086593948g24drpqiiyc8x6";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Plugin routing";
      longDescription = ''
        Library for building and parsing plugin URLs.
      '';
      platform = platforms.all;
    };
  });
  script-module-tzlocal = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-tzlocal";
    namespace = "script.module.tzlocal";
    version = "2.0.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.tzlocal/script.module.tzlocal-2.0.0+matrix.1.zip";
      sha256 = "02mh8cwdr5p7i1svrcbc3d8yfhaarbvaj9p4989zpp4zqqncqkly";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pytz # version 2019.3.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: tzlocal";
      longDescription = ''
        Packed for Kodi from https://github.com/regebro/tzlocal, forked from https://github.com/jdollarKodi/script.module.tzlocal
      '';
      homepage = "https://github.com/regebro/tzlocal";
      platform = platforms.all;
    };
  });
  script-module-urllib3 = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-urllib3";
    namespace = "script.module.urllib3";
    version = "1.25.8+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.urllib3/script.module.urllib3-1.25.8+matrix.1.zip";
      sha256 = "080yq8ns0sag6rmdag1hjwi0whcmp35wzqjp3by92m81cpszs75q";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: urllib3";
      longDescription = ''
        Packed for KODI from https://pypi.org/project/urllib3/
      '';
      homepage = "https://urllib3.readthedocs.io/en/latest/";
      platform = platforms.all;
    };
  });
  script-module-sseclient = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-sseclient";
    namespace = "script.module.sseclient";
    version = "0.0.24+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.sseclient/script.module.sseclient-0.0.24+matrix.1.zip";
      sha256 = "1kfbvgmq2dbwvca5mn4a2s78lb5ysvj9f4rd13kvg3i0ccqg1l9j";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.22.0+matrix.1
      script-module-six # version 1.14.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: sseclient";
      longDescription = ''
        Packed for KODI from https://github.com/btubbs/sseclient
      '';
      homepage = "https://github.com/btubbs/sseclient";
      platform = platforms.all;
    };
  });
  script-module-requests = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-requests";
    namespace = "script.module.requests";
    version = "2.22.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.requests/script.module.requests-2.22.0+matrix.1.zip";
      sha256 = "09576galkyzhw8fhy2h4aablm5rm2v08g0mdmg9nn55dlxhkkljq";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-certifi # version 2019.11.28+matrix.1
      script-module-chardet # version 3.0.4+matrix.1
      script-module-idna # version 2.8.1+matrix.1
      script-module-urllib3 # version 1.25.8+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: requests";
      longDescription = ''
        Packed for KODI from https://pypi.org/project/requests/
      '';
      homepage = "http://python-requests.org";
      platform = platforms.all;
    };
  });
  script-module-pyscrypt = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyscrypt";
    namespace = "script.module.pyscrypt";
    version = "1.6.2+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyscrypt/script.module.pyscrypt-1.6.2+matrix.1.zip";
      sha256 = "1mdv4mwvihbh9d2pwqhcmycjdnpa666y742lfscgmjr0q5q0bfa2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: PyScrypt";
      longDescription = ''
        A very simple, pure-Python implementation of the scrypt password-based key derivation function and scrypt file format library with no dependencies beyond standard Python libraries.
      '';
      homepage = "https://github.com/ricmoo/pyscrypt";
      platform = platforms.all;
    };
  });
  script-module-pysocks = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pysocks";
    namespace = "script.module.pysocks";
    version = "1.7.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pysocks/script.module.pysocks-1.7.0+matrix.1.zip";
      sha256 = "0bg8p5310251pvp41n6v84x9nqfyq426vdhff5p2aqmlrqhypvla";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: PySocks";
      longDescription = ''
        PySocks lets you send traffic through SOCKS and HTTP proxy servers. It is a modern fork of SocksiPy with bug fixes and extra features.
      '';
      homepage = "https://github.com/Anorov/PySocks";
      platform = platforms.all;
    };
  });
  script-module-pyaes = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-pyaes";
    namespace = "script.module.pyaes";
    version = "1.6.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.pyaes/script.module.pyaes-1.6.1+matrix.1.zip";
      sha256 = "0asbbv4i61zrdabkiaxgdprs0z5vdbwimbh13z8yiv7r38wnfvvn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: PyAES";
      longDescription = ''
        A pure-Python implementation of the AES (FIPS-197) block-cipher algorithm and common modes of operation (CBC, CFB, CTR, ECB, OFB) with no dependencies beyond standard Python libraries. See README.md for API reference and details.
      '';
      homepage = "https://github.com/ricmoo/pyaes";
      platform = platforms.all;
    };
  });
  script-module-myconnpy = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-myconnpy";
    namespace = "script.module.myconnpy";
    version = "8.0.18+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.myconnpy/script.module.myconnpy-8.0.18+matrix.1.zip";
      sha256 = "1cx3qdzw9lkkmbyvyrmc2i193is20fihn2sfl7kmv43f708vam0k";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: MySQL Connector/Python";
      longDescription = ''
        MySQL Connector/Python is implementing the MySQL Client/Server protocol completely in Python. This means you don't have to compile anything or MySQL (client library) doesn't even have to be installed on the machine.
      '';
      homepage = "http://dev.mysql.com/doc/connector-python/en/index.html";
      platform = platforms.all;
    };
  });
  script-module-htmlement = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-htmlement";
    namespace = "script.module.htmlement";
    version = "1.0.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.htmlement/script.module.htmlement-1.0.0+matrix.1.zip";
      sha256 = "13zzdzj44qk73xvamj00bcnklf397r1bh33rz0w96yj7j2ql7kq2";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: HTMLement";
      longDescription = ''
        Parses HTML using HTMLParser to build a tree of Elements. Utilizing ElementTree support for XPath expression to parse the tree.
      '';
      homepage = "https://python-htmlement.readthedocs.io/en/stable/?badge=stable";
      platform = platforms.all;
    };
  });
  script-module-idna = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-idna";
    namespace = "script.module.idna";
    version = "2.8.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.idna/script.module.idna-2.8.1+matrix.1.zip";
      sha256 = "02s75fhfmbs3a38wvxba51aj3lv5bidshjdkl6yjfji6waxpr9xh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: idna";
      longDescription = ''
        Packed for KODI from https://github.com/kjd/idna
      '';
      homepage = "https://github.com/kjd/idna";
      platform = platforms.all;
    };
  });
  script-module-ijson = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-ijson";
    namespace = "script.module.ijson";
    version = "2.6.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.ijson/script.module.ijson-2.6.1+matrix.1.zip";
      sha256 = "07zmycpms6gkn4lpvxnjjg5md4zavxp0dgvhpj3kjmh0b1hzdfl1";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: ijson";
      longDescription = ''
        Packed for KODI from https://github.com/isagalaev/ijson
      '';
      homepage = "https://pypi.org/project/ijson/";
      platform = platforms.all;
    };
  });
  script-module-monotonic = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-monotonic";
    namespace = "script.module.monotonic";
    version = "1.5.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.monotonic/script.module.monotonic-1.5.0+matrix.1.zip";
      sha256 = "17cacsmdyhkznlgcbmysllfan0jvn604js3km1sg6920cdx8g1ga";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: monotonic";
      longDescription = ''
        Packed for KODI from https://github.com/atdt/monotonic
      '';
      homepage = "https://github.com/btubbs/sseclient";
      platform = platforms.all;
    };
  });
  script-module-googleapi = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-googleapi";
    namespace = "script.module.googleapi";
    version = "1.6.7+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.googleapi/script.module.googleapi-1.6.7+matrix.1.zip";
      sha256 = "1kqnm29gyw8r9jnvki8lsa2wvbsnag17g40cgfq361l95paxgsmh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-httplib2 # version 0.17.0+matrix.1
      script-module-oauth2client # version 4.1.3+matrix.1
      script-module-six # version 1.14.0+matrix.1
      script-module-uritemplate # version 3.0.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: googleapi";
      longDescription = ''
        A packaged version of all the libraries needed for Google API access via python.
      '';
      homepage = "https://developers.google.com/api-client-library/python/start/installation";
      platform = platforms.all;
    };
  });
  script-module-dateutil = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-dateutil";
    namespace = "script.module.dateutil";
    version = "2.8.1+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.dateutil/script.module.dateutil-2.8.1+matrix.1.zip";
      sha256 = "1jr77017ihs7j3455i72af71wyvs792kbizq4539ccd98far8lm7";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-six # version 1.14.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: python-dateutil";
      longDescription = ''
        The dateutil module provides powerful extensions to the standard datetime module, available in Python.
      '';
      homepage = "https://dateutil.readthedocs.io/en/stable/";
      platform = platforms.all;
    };
  });
  script-module-defusedxml = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-defusedxml";
    namespace = "script.module.defusedxml";
    version = "0.6.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.defusedxml/script.module.defusedxml-0.6.0+matrix.1.zip";
      sha256 = "026i5rx9rmxcc18ixp6qhbryqdl4pn7cbwqicrishivan6apnacd";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: defusedxml";
      longDescription = ''
        Packed for KODI from https://github.com/tiran/defusedxml
      '';
      homepage = "https://pypi.org/project/defusedxml/";
      platform = platforms.all;
    };
  });
  script-module-dropbox = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-dropbox";
    namespace = "script.module.dropbox";
    version = "9.4.0+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.dropbox/script.module.dropbox-9.4.0+matrix.1.zip";
      sha256 = "1mk3shp4y9k1k55yv91k82kl5z9saqvki4n922wsk0f2rg8xcwhh";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-requests # version 2.18.4+matrix.1
      script-module-six # version 1.14.0+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: Dropbox API";
      longDescription = ''
        Provide Dropbox Python API support
      '';
      homepage = "https://www.dropbox.com/developers/documentation/python";
      platform = platforms.all;
    };
  });
  script-module-certifi = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-certifi";
    namespace = "script.module.certifi";
    version = "2019.11.28+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.certifi/script.module.certifi-2019.11.28+matrix.1.zip";
      sha256 = "0vsd68izv1ix0hb1gm74qq3zff0sxmhfhjyh7y9005zzp2gpi62v";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: certifi";
      longDescription = ''
        Certifi is a carefully curated collection of Root Certificates for validating the trustworthiness of SSL certificates while verifying the identity of TLS hosts. It has been extracted from the Requests project.
      '';
      homepage = "https://certifi.io";
      platform = platforms.all;
    };
  });
  script-module-arrow = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-arrow";
    namespace = "script.module.arrow";
    version = "0.15.5+matrix.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.arrow/script.module.arrow-0.15.5+matrix.1.zip";
      sha256 = "12wjhdf4lfnh7h4fwcdbls41a1p4xaw8cq2fbzykjg0cpa55c8xm";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-dateutil # version 2.8.1+matrix.1
    ];
    meta = with lib; {
      description = "Kodi addon: arrow";
      longDescription = ''
        Packed for Kodi from https://github.com/crsmithdev/arrow
      '';
      platform = platforms.all;
    };
  });
  script-module-kodi-six = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-module-kodi-six";
    namespace = "script.module.kodi-six";
    version = "0.1.3.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.module.kodi-six/script.module.kodi-six-0.1.3.1.zip";
      sha256 = "14m232p9hx925pbk8knsg994m1nbpa5278zmcrnfblh4z84gjv4x";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Kodi Six";
      longDescription = ''
        Wrappers around Kodi Python API that normalize handling of textual and byte strings in Python 2 and 3.
      '';
      platform = platforms.all;
    };
  });
  plugin-program-autocompletion = mkKodiPlugin {
    plugin = "plugin-program-autocompletion";
    namespace = "plugin.program.autocompletion";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/plugin.program.autocompletion/plugin.program.autocompletion-2.0.0.zip";
      sha256 = "1xdwabcdi626y8k0bhc2ljxfq3xvvykwm40rswxgsp3avgy3ddnn";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-autocompletion # version 2.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: AutoCompletion for virtual keyboard";
      longDescription = ''
        AutoCompletion for the virtual keyboard (needs skin support)
      '';
      platform = platforms.all;
    };
  };
  script-toolbox = mkKodiPlugin {
    plugin = "script-toolbox";
    namespace = "script.toolbox";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.toolbox/script.toolbox-2.0.0.zip";
      sha256 = "1bxq409w2lfhqdljxhch2by9fy1mvilcksk61i2mr02xvqqcnpjc";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
      script-module-pil # version 1.1.7
    ];
    meta = with lib; {
      description = "Kodi addon: ToolBox Script";
      longDescription = ''
        This script exposes several python functions to the UI engine as well as some other stuff to make life for skinners a bit easier.
      '';
      platform = platforms.all;
    };
  };
  webinterface-hax = mkKodiPlugin {
    plugin = "webinterface-hax";
    namespace = "webinterface.hax";
    version = "0.1.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/webinterface.hax/webinterface.hax-0.1.1.zip";
      sha256 = "0knqqsjdpcyp1kv3604bnvkcy4xz2k0fmz4ppnwgiwmd7qycmbgl";
    };
    propagatedBuildInputs = [
      xbmc-json # version 6.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Hax";
      longDescription = ''
        Intended to be used as a replacement for a remote control, Hax turns your phone, tablet or other device into a remote control with a simplified media library browser.
      '';
      platform = platforms.all;
    };
  };
  webinterface-chorus = mkKodiPlugin {
    plugin = "webinterface-chorus";
    namespace = "webinterface.chorus";
    version = "0.3.10";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/webinterface.chorus/webinterface.chorus-0.3.10.zip";
      sha256 = "074rfqqrw1xhxa80jgpy1yi0k3ll800y2fs4wpa4rvx8jad0l4k1";
    };
    propagatedBuildInputs = [
      xbmc-json # version 6.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Chorus";
      longDescription = ''
        A modern Web UI for your XBMC. Browse your Music, Movies or TV Shows from the comfort of your own web browser.  You can play media via XBMC or stream it in your browser. Works best with Chrome but plays well with most modern browsers. For more, see github.com/jez500/chorus
      '';
      platform = platforms.all;
    };
  };
  webinterface-awxi = mkKodiPlugin {
    plugin = "webinterface-awxi";
    namespace = "webinterface.awxi";
    version = "0.7.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/webinterface.awxi/webinterface.awxi-0.7.6.zip";
      sha256 = "1v0vy2640ri4hwinhi5kvkind279snbv195ls0w73ynir3pqwkai";
    };
    propagatedBuildInputs = [
      xbmc-json # version 6.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: AWXi";
      longDescription = ''
        You can use this webinterface to control the Audio/Video Section of XBMC: play/pause/stop/skip, show artists/albums/movies/tv shows and play them or add them to the playlist. It's designed for use on PCs or laptops with a browser like FireFox which supports JavaScript.

        Minimum requirements: XBMC Frodo
        Tested Browsers:
         - FireFox
         - Chromium
         - Internet Explorer 9
        Not supported: Internet Explorer 6

        Hint: You may need to clear your browser-cache before you open the new installed/updated webinterface in your browser. It is highly recommended that you use a browser capable of using web sockets. IE 9 is not one of them.
      '';
      platform = platforms.all;
    };
  };
  webinterface-arch = mkKodiPlugin {
    plugin = "webinterface-arch";
    namespace = "webinterface.arch";
    version = "2.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/webinterface.arch/webinterface.arch-2.0.5.zip";
      sha256 = "0f6whk4hjjg0yyhyk29mkmxkg9pq6fvvhfgkw8a7mg4gf3ifhxid";
    };
    propagatedBuildInputs = [
      xbmc-json # version 6.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Arch";
      longDescription = ''
        A modern web interface for KODI. Browse all your movies, tv shows and musics. See what's currently playing. Discover new movies and tv shows. All from your browser, desktop or tablets.
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-xperience1080 = mkKodiPlugin {
    plugin = "resource-uisounds-xperience1080";
    namespace = "resource.uisounds.xperience1080";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.xperience1080/resource.uisounds.xperience1080-1.0.0.zip";
      sha256 = "12s6yd6rqnln0qa9zs3i4gjrm8k8w3x5i1czfr3z67c44lp6v81i";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Xperience1080 UI Sounds";
      longDescription = ''
        Xperience1080 UI Sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-titan-modern = mkKodiPlugin {
    plugin = "resource-uisounds-titan-modern";
    namespace = "resource.uisounds.titan.modern";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.titan.modern/resource.uisounds.titan.modern-1.0.0.zip";
      sha256 = "1865c7ikw9nlnfbrhrzqnaqr2wh9p2s8h8jafd2xvs63qjv041z2";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Titan UI Sounds (Modern)";
      longDescription = ''
        Titan UI Sounds (Modern)
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-transparency = mkKodiPlugin {
    plugin = "resource-uisounds-transparency";
    namespace = "resource.uisounds.transparency";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.transparency/resource.uisounds.transparency-0.0.1.zip";
      sha256 = "0wfz9i4sjvbf92iyyv26yansn5gr9jb9v2v301vnb8y6dqa5idi7";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Transparency! UI Sounds";
      longDescription = ''
        Transparency! GUI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-refocus = mkKodiPlugin {
    plugin = "resource-uisounds-refocus";
    namespace = "resource.uisounds.refocus";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.refocus/resource.uisounds.refocus-1.0.0.zip";
      sha256 = "11lknz1qafpnl83dwgd7rjvhl1h5kifsbb15b0j1km38xpp7bgka";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: reFocus UI Sounds";
      longDescription = ''
        reFocus UI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-titan-classic = mkKodiPlugin {
    plugin = "resource-uisounds-titan-classic";
    namespace = "resource.uisounds.titan.classic";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.titan.classic/resource.uisounds.titan.classic-1.0.0.zip";
      sha256 = "0cz18ai7n1nc50zkl5m47par6fqsqjcy28lfh3adrg4710vgg8xv";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Titan UI Sounds (Classic)";
      longDescription = ''
        Titan UI Sounds (Classic)
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-rapier = mkKodiPlugin {
    plugin = "resource-uisounds-rapier";
    namespace = "resource.uisounds.rapier";
    version = "1.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.rapier/resource.uisounds.rapier-1.0.2.zip";
      sha256 = "1z2l5g4xmdm3fd9j09zkjs26dh2fyjw46jyyy74c0kc1xs7i1l54";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Rapier UI Sounds";
      longDescription = ''
        Rapier GUI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-nebula = mkKodiPlugin {
    plugin = "resource-uisounds-nebula";
    namespace = "resource.uisounds.nebula";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.nebula/resource.uisounds.nebula-1.0.1.zip";
      sha256 = "1nlz6c84504x8vkayc99i7c0ckza2yfxypnywn7jvzz0f9jd6p1g";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Nebula UI Sounds";
      longDescription = ''
        Nebula GUI sounds created for the Nebula skin by Tgx
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-grid = mkKodiPlugin {
    plugin = "resource-uisounds-grid";
    namespace = "resource.uisounds.grid";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.grid/resource.uisounds.grid-1.0.0.zip";
      sha256 = "1akfmjsb0ci9l8gpi5d3n26kawvlzahyngq2azc3hfdx63011j5g";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Grid UI Sounds";
      longDescription = ''
        Grid UI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-ftv = mkKodiPlugin {
    plugin = "resource-uisounds-ftv";
    namespace = "resource.uisounds.ftv";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.ftv/resource.uisounds.ftv-1.0.0.zip";
      sha256 = "104sfsvng9yskmanraybrdxqimp9zs7kgc5d636r91v1y8v6i4nk";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: fTV Sounds";
      longDescription = ''
        fTV Sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-embuary = mkKodiPlugin {
    plugin = "resource-uisounds-embuary";
    namespace = "resource.uisounds.embuary";
    version = "0.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.embuary/resource.uisounds.embuary-0.0.4.zip";
      sha256 = "00yg3kdkzd6pjispzlks1gaq67j5i2x54nyz8a2v7yf8ipv3rjjz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Embuary Sounds";
      longDescription = ''
        To simulate the sound theme of EmbyTheater
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-fromashes = mkKodiPlugin {
    plugin = "resource-uisounds-fromashes";
    namespace = "resource.uisounds.fromashes";
    version = "3.0.01";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.fromashes/resource.uisounds.fromashes-3.0.01.zip";
      sha256 = "1vjf3q612832rfnii6gwdk7fg6lvhqv4v69mzf7zgaa2j506qn62";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Arctic Zephyr: From Ashes UI Audio Suite";
      longDescription = ''
        Arctic Zephyr: From Ashes UI Audio Suite
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-white = mkKodiPlugin {
    plugin = "resource-images-weathericons-white";
    namespace = "resource.images.weathericons.white";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.white/resource.images.weathericons.white-0.0.6.zip";
      sha256 = "0yqymz9jjac3b3fvl5kkcxfi2k40bhigq8sb6ppc774aiw35i2b9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - White";
      longDescription = ''
        White Weather Icons
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-aeonmq6 = mkKodiPlugin {
    plugin = "resource-uisounds-aeonmq6";
    namespace = "resource.uisounds.aeonmq6";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.aeonmq6/resource.uisounds.aeonmq6-1.0.0.zip";
      sha256 = "0c8kxb6lxscb2zzxbxwb5zvji5a7g3fgcb3wmi8qhsziaza59pwk";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Aeon MQ 6 UI Sounds";
      longDescription = ''
        Aeon MQ 6 UI Sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-amber = mkKodiPlugin {
    plugin = "resource-uisounds-amber";
    namespace = "resource.uisounds.amber";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.amber/resource.uisounds.amber-1.0.0.zip";
      sha256 = "1hs8mchw5jx2kknff95xp3dnh5jl9xhd81q4n1vx3y2w28573bls";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Amber UI Sounds";
      longDescription = ''
        Amber UI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-androidtv = mkKodiPlugin {
    plugin = "resource-uisounds-androidtv";
    namespace = "resource.uisounds.androidtv";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.androidtv/resource.uisounds.androidtv-1.0.0.zip";
      sha256 = "0r12ih8a7xfcy33l94d8a8bf4n343zf86jgac7xq7mxcs27jama4";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Android TV UI Sounds";
      longDescription = ''
        GUI sounds from the Android TV Launcer.
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-appletv = mkKodiPlugin {
    plugin = "resource-uisounds-appletv";
    namespace = "resource.uisounds.appletv";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.appletv/resource.uisounds.appletv-0.0.2.zip";
      sha256 = "0829h9bni5a8zs2qka09ajsgc058mpz5d597zfn43iq3fcwmcm4m";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: AppleTv UI Sounds";
      longDescription = ''
        AppleTv navigation sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-apptv = mkKodiPlugin {
    plugin = "resource-uisounds-apptv";
    namespace = "resource.uisounds.apptv";
    version = "1.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.apptv/resource.uisounds.apptv-1.0.4.zip";
      sha256 = "1bffl9m1qjjcb3ryhhkaa3jajg93hzliri7k423lc3vp6y3lhsyn";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: AppTV UI Sounds";
      longDescription = ''
        AppTV GUI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-backrow = mkKodiPlugin {
    plugin = "resource-uisounds-backrow";
    namespace = "resource.uisounds.backrow";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.backrow/resource.uisounds.backrow-1.0.0.zip";
      sha256 = "0jfjnl90sc2s68rwbgjybbv3aybawqhmswdmqhf8dwqar7n9jgs1";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Back Row UI Sounds";
      longDescription = ''
        Back Row GUI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-uisounds-bursting-bubbles = mkKodiPlugin {
    plugin = "resource-uisounds-bursting-bubbles";
    namespace = "resource.uisounds.bursting-bubbles";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.uisounds.bursting-bubbles/resource.uisounds.bursting-bubbles-1.0.0.zip";
      sha256 = "1vv4xnrhxq8w13dbrqnf4cm6gddbfbxv16qmd72m84cl4iz46q4b";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Bursting Bubbles";
      longDescription = ''
        Bursting Bubbles GUI sounds
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-transparent = mkKodiPlugin {
    plugin = "resource-images-weathericons-transparent";
    namespace = "resource.images.weathericons.transparent";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.transparent/resource.images.weathericons.transparent-0.0.6.zip";
      sha256 = "1ds4w0yn70h6xix80hg38sk8vs3rdb9f6ki18ss1sj6g8bzw8vl5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Transparent";
      longDescription = ''
        Weather Icons in a slightly transparent style
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-outline-hd = mkKodiPlugin {
    plugin = "resource-images-weathericons-outline-hd";
    namespace = "resource.images.weathericons.outline-hd";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.outline-hd/resource.images.weathericons.outline-hd-0.0.3.zip";
      sha256 = "1r8acbzbaf8j8da654cry2jw6d738s4wbzszvk5vafnkjvf8792p";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Outline HD";
      longDescription = ''
        Weather Icons in an outline style, based on the weather icons project by Erik Flowers. http://erikflowers.github.io/weather-icons/
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  resource-images-weathericons-monstr = mkKodiPlugin {
    plugin = "resource-images-weathericons-monstr";
    namespace = "resource.images.weathericons.monstr";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.monstr/resource.images.weathericons.monstr-0.0.2.zip";
      sha256 = "1icd3vivkxw5s1gg8wajx6md7g3n9xqy5fqji66hskwhickzyj44";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Monstr";
      longDescription = ''
        Weather icon pack created from icons courtesy of iconmonstr.com
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  resource-images-weathericons-outline = mkKodiPlugin {
    plugin = "resource-images-weathericons-outline";
    namespace = "resource.images.weathericons.outline";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.outline/resource.images.weathericons.outline-0.0.6.zip";
      sha256 = "10fld8mardmg42m6abldskkd7gv7nvya2k4g9w0f9s6llzda2w3s";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Outline";
      longDescription = ''
        Weather Icons in an outline style
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-hd-animated = mkKodiPlugin {
    plugin = "resource-images-weathericons-hd-animated";
    namespace = "resource.images.weathericons.hd.animated";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.hd.animated/resource.images.weathericons.hd.animated-1.0.0.zip";
      sha256 = "08rc8whbssfygdnh7cgfdfjcw31dxnmlwpvkyanvd6hgfnl9yp3n";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - HD Animated";
      longDescription = ''
        Custom Animated Weather Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-flat = mkKodiPlugin {
    plugin = "resource-images-weathericons-flat";
    namespace = "resource.images.weathericons.flat";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.flat/resource.images.weathericons.flat-0.0.6.zip";
      sha256 = "14lqhkgs8360dqjirb6xkm7lpqy8q554d9r9dmpxvnq14dishzaj";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Flat";
      longDescription = ''
        Weather Icons in a flat style
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-grey = mkKodiPlugin {
    plugin = "resource-images-weathericons-grey";
    namespace = "resource.images.weathericons.grey";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.grey/resource.images.weathericons.grey-0.0.6.zip";
      sha256 = "0h5c2srd7j8bd38inkdlplfx7z987ky88488gjk0wvgrqhavsgn6";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Grey";
      longDescription = ''
        Grey Weather Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-coloured = mkKodiPlugin {
    plugin = "resource-images-weathericons-coloured";
    namespace = "resource.images.weathericons.coloured";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.coloured/resource.images.weathericons.coloured-0.0.6.zip";
      sha256 = "1wwch6bsiixf4vlpnd36yqvh1bi3cyk787js7b8gkh3jffhbya00";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Coloured";
      longDescription = ''
        Coloured Weather Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-cloud-animated = mkKodiPlugin {
    plugin = "resource-images-weathericons-cloud-animated";
    namespace = "resource.images.weathericons.cloud.animated";
    version = "2.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.cloud.animated/resource.images.weathericons.cloud.animated-2.0.0.zip";
      sha256 = "171gqzzlgwr1wkd7h7y26jjvr493ra168gqpghwyi936rgvffmnz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Cloud Animated";
      longDescription = ''
        Custom Animated Weather Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-animated = mkKodiPlugin {
    plugin = "resource-images-weathericons-animated";
    namespace = "resource.images.weathericons.animated";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.animated/resource.images.weathericons.animated-0.0.6.zip";
      sha256 = "1fppkfj9s23qrmmr0h7hqk47bcjip50qr748864gf60z5l2w0wjz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - Animated";
      longDescription = ''
        Animated Weather Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-3d-coloured = mkKodiPlugin {
    plugin = "resource-images-weathericons-3d-coloured";
    namespace = "resource.images.weathericons.3d-coloured";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.3d-coloured/resource.images.weathericons.3d-coloured-0.0.6.zip";
      sha256 = "17yxi4rqlsy8m9n56bkzj42j841k2sc6zs8j3ba1kjhbksyzafv7";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - 3D Coloured";
      longDescription = ''
        Coloured Weather Icons in a 3D style
      '';
      platform = platforms.all;
    };
  };
  resource-images-weathericons-3d-white = mkKodiPlugin {
    plugin = "resource-images-weathericons-3d-white";
    namespace = "resource.images.weathericons.3d-white";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weathericons.3d-white/resource.images.weathericons.3d-white-0.0.6.zip";
      sha256 = "010wwskhc0b6l2qip9lw26n8pkvq6sgbhlaiyrynr9zc4x8f7q24";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Icons - 3D White";
      longDescription = ''
        White Weather Icons in a 3D style
      '';
      platform = platforms.all;
    };
  };
  resource-images-weatherfanart-single = mkKodiPlugin {
    plugin = "resource-images-weatherfanart-single";
    namespace = "resource.images.weatherfanart.single";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weatherfanart.single/resource.images.weatherfanart.single-0.0.6.zip";
      sha256 = "02pxw1qqzlvvmw1bxg4mfh461lwwin32za7vn5g428ayv7f4zymw";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Fanart - Single";
      longDescription = ''
        A single Weather Fanart image for every weather condition
      '';
      platform = platforms.all;
    };
  };
  resource-images-weatherfanart-prairie = mkKodiPlugin {
    plugin = "resource-images-weatherfanart-prairie";
    namespace = "resource.images.weatherfanart.prairie";
    version = "0.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weatherfanart.prairie/resource.images.weatherfanart.prairie-0.0.5.zip";
      sha256 = "1060pkbv3vqdiwjaklcwqq0vd5kzsig7vhhaydp7fj0aldflmcn5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Fanart - Prairie";
      longDescription = ''
        Weather Fanart based on variations of the Little House On The Prairie image.
      '';
      platform = platforms.all;
    };
  };
  resource-images-weatherfanart-multi = mkKodiPlugin {
    plugin = "resource-images-weatherfanart-multi";
    namespace = "resource.images.weatherfanart.multi";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weatherfanart.multi/resource.images.weatherfanart.multi-0.0.6.zip";
      sha256 = "01ldfb3qjrjz8rwh650sn5zy6pz5y7fxc8znldnd18ssd48mb4w5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Fanart - Multi";
      longDescription = ''
        Multiple Weather Fanart images for every weather condition
      '';
      platform = platforms.all;
    };
  };
  resource-images-weatherfanart-faded = mkKodiPlugin {
    plugin = "resource-images-weatherfanart-faded";
    namespace = "resource.images.weatherfanart.faded";
    version = "0.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.weatherfanart.faded/resource.images.weatherfanart.faded-0.0.4.zip";
      sha256 = "0qsvqjxrgmxcd7m29vq2qmff5zfi4npjsgadm9013wfimq8lgskm";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Weather Fanart - Faded";
      longDescription = ''
        Weather Fanart in a faded style
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinthemes-aeonmq = mkKodiPlugin {
    plugin = "resource-images-skinthemes-aeonmq";
    namespace = "resource.images.skinthemes.aeonmq";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinthemes.aeonmq/resource.images.skinthemes.aeonmq-0.0.2.zip";
      sha256 = "0vd9h92g0lklmr995i95j3lb6z25wkyd99cv2rhb12abci087ryn";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Themes - Aeon MQ";
      longDescription = ''
        Compatible with skin Aeon MQ 7
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-wide = mkKodiPlugin {
    plugin = "resource-images-skinicons-wide";
    namespace = "resource.images.skinicons.wide";
    version = "1.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.wide/resource.images.skinicons.wide-1.0.3.zip";
      sha256 = "0i7ibgm5br9nlhsdxqq3qdi20ihsy7dlwsadh771kj1xh2fw6ql9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Wide";
      longDescription = ''
        Skin Icons Pack - Wide
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-squares = mkKodiPlugin {
    plugin = "resource-images-skinicons-squares";
    namespace = "resource.images.skinicons.squares";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.squares/resource.images.skinicons.squares-1.0.1.zip";
      sha256 = "1hkcanpk5ml0j2y4cg7dmih97070mslmd71bywqz66z003z71522";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Squares";
      longDescription = ''
        Skin Icons Pack - Squares
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-skyrim = mkKodiPlugin {
    plugin = "resource-images-skinicons-skyrim";
    namespace = "resource.images.skinicons.skyrim";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.skyrim/resource.images.skinicons.skyrim-1.0.1.zip";
      sha256 = "1xvivxdbkyhd9k1j7qc7h407z2xjk5aa88ilj7kp7x6va5zbpvj5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Skyrim Design";
      longDescription = ''
        Skin Icons Pack - Skyrim Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-silver = mkKodiPlugin {
    plugin = "resource-images-skinicons-silver";
    namespace = "resource.images.skinicons.silver";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.silver/resource.images.skinicons.silver-1.0.1.zip";
      sha256 = "06wgqvl37dk0nn25pjymdnk9yi1msws0whvs2j1vkainv3x6p2j7";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Silver Design";
      longDescription = ''
        Skin Icons Pack - Silver Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-ring = mkKodiPlugin {
    plugin = "resource-images-skinicons-ring";
    namespace = "resource.images.skinicons.ring";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.ring/resource.images.skinicons.ring-1.0.1.zip";
      sha256 = "01489p38j9da8827v70d0x8s4y6kwmg8c23mfnpji9k98c00cinz";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Ring Design";
      longDescription = ''
        Skin Icons Pack - Ring Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-cd = mkKodiPlugin {
    plugin = "resource-images-skinicons-cd";
    namespace = "resource.images.skinicons.cd";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.cd/resource.images.skinicons.cd-1.0.1.zip";
      sha256 = "1i1by90d06lpbqyldhz5yxgcpq63dmwwcqmw82gdscgysl7hhqs5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - CD Design";
      longDescription = ''
        Skin Icons Pack - CD Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-classicwhite = mkKodiPlugin {
    plugin = "resource-images-skinicons-classicwhite";
    namespace = "resource.images.skinicons.classicwhite";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.classicwhite/resource.images.skinicons.classicwhite-1.0.1.zip";
      sha256 = "11h3nk92rardq23ql0w9dqsgy70jswp57zj02vgckjrdiilbhqw7";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Classic White Design";
      longDescription = ''
        Skin Icons Pack - Classic White Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-darkwood = mkKodiPlugin {
    plugin = "resource-images-skinicons-darkwood";
    namespace = "resource.images.skinicons.darkwood";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.darkwood/resource.images.skinicons.darkwood-1.0.1.zip";
      sha256 = "0p83nw3w90dgaxc0bqxsmx5idiwm1bsdn3cj38kj2cxf1fqdndxg";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Darkwood Design";
      longDescription = ''
        Skin Icons Pack - Darkwood Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-zigzag = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-zigzag";
    namespace = "resource.images.skinbackgrounds.zigzag";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.zigzag/resource.images.skinbackgrounds.zigzag-1.0.1.zip";
      sha256 = "12fij508ag58qjs729ivq8qgsc4lix26cqn8pgzsp6ac1p7w970r";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - ZigZag Design";
      longDescription = ''
        Skin Backgrounds Pack - ZigZag Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinicons-boss = mkKodiPlugin {
    plugin = "resource-images-skinicons-boss";
    namespace = "resource.images.skinicons.boss";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinicons.boss/resource.images.skinicons.boss-1.0.1.zip";
      sha256 = "1yzckikhl64scw110y44qwk2bylcx1b4hbkn183b37ldw2cnjbqy";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Icons - Boss Design";
      longDescription = ''
        Skin Icons Pack - Boss Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-wallsquare = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-wallsquare";
    namespace = "resource.images.skinbackgrounds.wallsquare";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.wallsquare/resource.images.skinbackgrounds.wallsquare-1.0.1.zip";
      sha256 = "0r4kg5clq3y4hww8wqki8ajj2hsdw8lrvdydc7lsgxxkzyhqv3v0";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Wall Square";
      longDescription = ''
        Skin Backgrounds Pack - Wall Square Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-titanium = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-titanium";
    namespace = "resource.images.skinbackgrounds.titanium";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.titanium/resource.images.skinbackgrounds.titanium-1.0.0.zip";
      sha256 = "1j4ca9an14syx0v0rfafcn1yh7wzfm22dk1spml4pylsvpdpzdqs";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Titanium";
      longDescription = ''
        Skin Backgrounds Pack - Titanium
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-silver = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-silver";
    namespace = "resource.images.skinbackgrounds.silver";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.silver/resource.images.skinbackgrounds.silver-1.0.1.zip";
      sha256 = "0m8icpmkghd3bmiw9k0f7q4w3gilfjpxbr06nqm6q94jfz36sg7s";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Silver Design";
      longDescription = ''
        Skin Backgrounds Pack - Silver Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-phenominence = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-phenominence";
    namespace = "resource.images.skinbackgrounds.phenominence";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.phenominence/resource.images.skinbackgrounds.phenominence-1.0.1.zip";
      sha256 = "0bq0gwk6y8br3sl45177w0spqzaiv93jkq05a37c9d2ykrr3b76b";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Phenominence Design";
      longDescription = ''
        Skin Backgrounds Pack - Phenominence Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-metrocity = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-metrocity";
    namespace = "resource.images.skinbackgrounds.metrocity";
    version = "1.1.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.metrocity/resource.images.skinbackgrounds.metrocity-1.1.0.zip";
      sha256 = "0r3pdfanv1zgpdd5ylf9sx9rsyvyh6y3q9xfy9ly911khvjfapyq";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Metrocity";
      longDescription = ''
        Photographic style skin background images.
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-diamond = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-diamond";
    namespace = "resource.images.skinbackgrounds.diamond";
    version = "1.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.diamond/resource.images.skinbackgrounds.diamond-1.0.2.zip";
      sha256 = "1kzf43fjhlj08gj7ih0h9jxq8nllghzbjmwkhwga4qwcawzbavpj";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Diamond Design";
      longDescription = ''
        Skin Backgrounds Pack - Diamond Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-darkwood = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-darkwood";
    namespace = "resource.images.skinbackgrounds.darkwood";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.darkwood/resource.images.skinbackgrounds.darkwood-1.0.1.zip";
      sha256 = "0pmkx7fkfmbibf3fdyixlz7az119va6jcsm0mh74yxqxixlv2141";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Darkwood Design";
      longDescription = ''
        Skin Backgrounds Pack - Darkwood Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-skinbackgrounds-clear = mkKodiPlugin {
    plugin = "resource-images-skinbackgrounds-clear";
    namespace = "resource.images.skinbackgrounds.clear";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.skinbackgrounds.clear/resource.images.skinbackgrounds.clear-1.0.1.zip";
      sha256 = "160qya08r4cbkjpj40v2gr5liawf33jzq6dqaidrm2hgsfkxlngn";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Skin Backgrounds - Clear Design";
      longDescription = ''
        Skin backgrounds Pack - Clear Design
      '';
      platform = platforms.all;
    };
  };
  resource-images-recordlabels-white = mkKodiPlugin {
    plugin = "resource-images-recordlabels-white";
    namespace = "resource.images.recordlabels.white";
    version = "0.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.recordlabels.white/resource.images.recordlabels.white-0.0.7.zip";
      sha256 = "0lk2hn0k638mn1yc3qk07glaqawpibzi7sj0qqnr332f9cqm7pj6";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Recordlabel Icons - White";
      longDescription = ''
        White Recordlabel Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-musicgenreicons-text = mkKodiPlugin {
    plugin = "resource-images-musicgenreicons-text";
    namespace = "resource.images.musicgenreicons.text";
    version = "0.1.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.musicgenreicons.text/resource.images.musicgenreicons.text-0.1.0.zip";
      sha256 = "1vydykx6vdznbninq2g19ngn1gbr4cnp7wm77id7jgxa4jknf01x";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Music Genre Icons - Text";
      longDescription = ''
        Music Genre Icons with text
      '';
      platform = platforms.all;
    };
  };
  resource-images-musicgenreicons-poster = mkKodiPlugin {
    plugin = "resource-images-musicgenreicons-poster";
    namespace = "resource.images.musicgenreicons.poster";
    version = "0.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.musicgenreicons.poster/resource.images.musicgenreicons.poster-0.0.7.zip";
      sha256 = "0kscp7q3x489m5mh7qyhlm3wpighhqi1ibzwx9pmfyidm5k8ib83";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Music Genre Icons - Poster";
      longDescription = ''
        Music Genre Icons in a poster style
      '';
      platform = platforms.all;
    };
  };
  resource-images-musicgenreicons-grey = mkKodiPlugin {
    plugin = "resource-images-musicgenreicons-grey";
    namespace = "resource.images.musicgenreicons.grey";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.musicgenreicons.grey/resource.images.musicgenreicons.grey-0.0.6.zip";
      sha256 = "19n63lifj0hj7x9cd99p3mp3pidhfrvj20n6lragz3acyyq4wwqk";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Music Genre Icons - Grey";
      longDescription = ''
        Grey Music Genre Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-musicgenrefanart-coloured = mkKodiPlugin {
    plugin = "resource-images-musicgenrefanart-coloured";
    namespace = "resource.images.musicgenrefanart.coloured";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.musicgenrefanart.coloured/resource.images.musicgenrefanart.coloured-0.0.3.zip";
      sha256 = "1a661jrgzaaqsrfsxw1nkag25snfcqiixqlkm3bhhm5b65kx34jk";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Music Genre Fanart - Coloured";
      longDescription = ''
        Coloured Music Genre Fanarts
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-xzener-reflection = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-xzener-reflection";
    namespace = "resource.images.moviegenreicons.xzener-reflection";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.xzener-reflection/resource.images.moviegenreicons.xzener-reflection-0.0.3.zip";
      sha256 = "0qzbzm9fzxrw3yci9dg49z1lk602fllkl961drzdqd0n8n4hfgyv";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Xzener's Reflected Icons";
      longDescription = ''
        Transparent Movie Genre Icons with reflection made by Xzener.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-xzener-flat = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-xzener-flat";
    namespace = "resource.images.moviegenreicons.xzener-flat";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.xzener-flat/resource.images.moviegenreicons.xzener-flat-0.0.3.zip";
      sha256 = "069fwjvmvnx46fmi91jm0f9pgpghrs8yfg8zq05x5bsy9f0a7q88";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Xzener's Flat Icons";
      longDescription = ''
        Transparent flat Movie Genre Icons made by Xzener.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-white = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-white";
    namespace = "resource.images.moviegenreicons.white";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.white/resource.images.moviegenreicons.white-0.0.6.zip";
      sha256 = "1ri81h67p070icb3xbah128dvxyj4kiyqbx4s22xxw3fvmg3d5dp";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - White";
      longDescription = ''
        Movie Genre Icons in black and white
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-transparent = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-transparent";
    namespace = "resource.images.moviegenreicons.transparent";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.transparent/resource.images.moviegenreicons.transparent-0.0.6.zip";
      sha256 = "0hza2g6rrdj9vq81k4dvrk8sc4dyix07jn0p58q9lvl3pqh41jas";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Transparent";
      longDescription = ''
        Movie Genre Icons with a transparent background
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-poster = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-poster";
    namespace = "resource.images.moviegenreicons.poster";
    version = "0.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.poster/resource.images.moviegenreicons.poster-0.0.7.zip";
      sha256 = "1hwb7lh39frfy0iqakhpdzy2gblwl9k0fl3h280d4zi22qkac2jh";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Poster";
      longDescription = ''
        Movie Genre Icons in a movie poster style
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-grey = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-grey";
    namespace = "resource.images.moviegenreicons.grey";
    version = "0.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.grey/resource.images.moviegenreicons.grey-0.0.7.zip";
      sha256 = "16dqfp7z3l519sav1k6akds862vlhkj8ngyng60kprzj61w93xbq";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Grey";
      longDescription = ''
        Grey Movie Genre Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-filmstrip = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-filmstrip";
    namespace = "resource.images.moviegenreicons.filmstrip";
    version = "0.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.filmstrip/resource.images.moviegenreicons.filmstrip-0.0.6.zip";
      sha256 = "09pm34czzw41m0rxq5xz3ykbkm6rh8fhwh0q38ls09s7lchagqnf";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Filmstrip";
      longDescription = ''
        Movie Genre Icons in a filmstrip style
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-coloured = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-coloured";
    namespace = "resource.images.moviegenreicons.coloured";
    version = "0.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.coloured/resource.images.moviegenreicons.coloured-0.0.8.zip";
      sha256 = "0ccnj6j08zi1j4hlx2p6mny7ndafxs0yv43pf81s4l6azpzdgra0";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Coloured";
      longDescription = ''
        Coloured Movie Genre Icons
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenreicons-arctic-zephyr = mkKodiPlugin {
    plugin = "resource-images-moviegenreicons-arctic-zephyr";
    namespace = "resource.images.moviegenreicons.arctic.zephyr";
    version = "0.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenreicons.arctic.zephyr/resource.images.moviegenreicons.arctic.zephyr-0.0.3.zip";
      sha256 = "04k9mh3ij0f1wl3f0cg1g0wfcbxzg99i2gbqnk7rd20mjxnf5cdp";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Icons - Arctic Zephyr";
      longDescription = ''
        Movie Genre Icons for Arctic Zephyr. Icons courtesy of iconfinder.com and iconmonstr.com.
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  resource-images-moviegenrefanart-wall-red = mkKodiPlugin {
    plugin = "resource-images-moviegenrefanart-wall-red";
    namespace = "resource.images.moviegenrefanart.wall-red";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenrefanart.wall-red/resource.images.moviegenrefanart.wall-red-0.0.1.zip";
      sha256 = "1gqn22bahyrd2lcr7dd4hszrzawbb6w5im2xfz19slmq98v7kgnx";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Fanart - Red Wall";
      longDescription = ''
        Red wall style movie genre fanart backgrounds by TBinfection and Gade.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenrefanart-wall-grey = mkKodiPlugin {
    plugin = "resource-images-moviegenrefanart-wall-grey";
    namespace = "resource.images.moviegenrefanart.wall-grey";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenrefanart.wall-grey/resource.images.moviegenrefanart.wall-grey-0.0.1.zip";
      sha256 = "0b7y88p7rin8v1vd2z3viv8wakghfwmlsykgvyqbh2rx7sk68zx9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Fanart - Grey Wall";
      longDescription = ''
        Grey wall style movie genre fanart backgrounds by TBinfection, Buff and Gade.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenrefanart-wall-blue = mkKodiPlugin {
    plugin = "resource-images-moviegenrefanart-wall-blue";
    namespace = "resource.images.moviegenrefanart.wall-blue";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenrefanart.wall-blue/resource.images.moviegenrefanart.wall-blue-0.0.1.zip";
      sha256 = "1d1ra9w8i6dfhk4n3cnkz9zl0y6l0qd2ls2ccrjahi2yxxb2jblc";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Fanart - Blue Wall";
      longDescription = ''
        Blue wall style movie genre fanart backgrounds by TBinfection and Gade.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenrefanart-panel = mkKodiPlugin {
    plugin = "resource-images-moviegenrefanart-panel";
    namespace = "resource.images.moviegenrefanart.panel";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenrefanart.panel/resource.images.moviegenrefanart.panel-0.0.2.zip";
      sha256 = "09mlkqk8fn0msf984i3df9sc65baivj3dvnwmdlad8l5149rxb61";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Fanart - Panel";
      longDescription = ''
        Movie Genre Fanarts in panel mode
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviegenrefanart-metrocity = mkKodiPlugin {
    plugin = "resource-images-moviegenrefanart-metrocity";
    namespace = "resource.images.moviegenrefanart.metrocity";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviegenrefanart.metrocity/resource.images.moviegenrefanart.metrocity-1.0.0.zip";
      sha256 = "1zqyb8mpni7rwvdb2si4gq7fq26gpdzn7avvy7fa17mcgdw6cn4x";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Genre Fanart - Metrocity";
      longDescription = ''
        Photographic style movie genre fanart backgrounds.
      '';
      platform = platforms.all;
    };
  };
  resource-images-moviecountryicons-flags = mkKodiPlugin {
    plugin = "resource-images-moviecountryicons-flags";
    namespace = "resource.images.moviecountryicons.flags";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviecountryicons.flags/resource.images.moviecountryicons.flags-0.0.1.zip";
      sha256 = "0513il77fqcnv9cnbiqdpw9pd3mx94vmn5dfb8qqynilhb2hcqy8";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Country Icons - Flags";
      longDescription = ''
        Flag icons for the Countries node in Movies. Flags courtesy of lipis, https://github.com/lipis/flag-icon-css
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  resource-images-moviecountryicons-maps = mkKodiPlugin {
    plugin = "resource-images-moviecountryicons-maps";
    namespace = "resource.images.moviecountryicons.maps";
    version = "0.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.moviecountryicons.maps/resource.images.moviecountryicons.maps-0.0.1.zip";
      sha256 = "0kswfws2p5pl230y3cs2vfn7zpfd64v31ymb4x06kgygdch2wky4";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Movie Country Icons - Maps";
      longDescription = ''
        Map icons for the Countries node in Movies. Maps courtesy of DJAISS, https://github.com/djaiss/mapsicon.
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  resource-images-languageflags-rounded = mkKodiPlugin {
    plugin = "resource-images-languageflags-rounded";
    namespace = "resource.images.languageflags.rounded";
    version = "0.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.languageflags.rounded/resource.images.languageflags.rounded-0.0.2.zip";
      sha256 = "0jc4x71bjc5ddm9msx2ibjqajanfrzyb3s56a9gkndaqv33crlk9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Language Flags Rounded";
      longDescription = ''
        Rounded coloured language flags. Icons by neurosis13.
      '';
      platform = platforms.all;
    };
  };
  resource-images-languageflags-completepack = mkKodiPlugin {
    plugin = "resource-images-languageflags-completepack";
    namespace = "resource.images.languageflags.completepack";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.languageflags.completepack/resource.images.languageflags.completepack-1.0.1.zip";
      sha256 = "0cahlar7glb2dad7ss6mwcz8i0dds5z3fx5kn0zakd71f0qd6s16";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Language Flags Complete Pack";
      longDescription = ''
        This add-on contains all of the language flags Kodi needs. All of the Kodi supported languages have been taken into account and if there's a flag and a code for it it's in here. I used https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes as a reference for the codes.
      '';
      platform = platforms.all;
    };
  };
  resource-images-languageflags-colour = mkKodiPlugin {
    plugin = "resource-images-languageflags-colour";
    namespace = "resource.images.languageflags.colour";
    version = "0.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.languageflags.colour/resource.images.languageflags.colour-0.0.4.zip";
      sha256 = "10c1i379c6p353vr93lybfsslp0710pjr1k3qpx65zpaxjswyskm";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Language Flags Colour";
      longDescription = ''
        Language flags in colour
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  resource-images-gamestudios-grayscale = mkKodiPlugin {
    plugin = "resource-images-gamestudios-grayscale";
    namespace = "resource.images.gamestudios.grayscale";
    version = "1.2.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.gamestudios.grayscale/resource.images.gamestudios.grayscale-1.2.0.zip";
      sha256 = "13fcvfdnm32srwx2ah6ba3ypayz1wyhkh4zdr6xb6pnj36sqjfy5";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Game Studio Icons (grayscale)";
      longDescription = ''
        Game Studio Icons (grayscale)
      '';
      platform = platforms.all;
    };
  };
  resource-images-busyspinners-basic = mkKodiPlugin {
    plugin = "resource-images-busyspinners-basic";
    namespace = "resource.images.busyspinners.basic";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.busyspinners.basic/resource.images.busyspinners.basic-1.0.0.zip";
      sha256 = "0knzv29hb9b1m9386srf29kfng0g1dypcaa1757z5mj6csjjb1sf";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Animated Busy Spinners Pack";
      longDescription = ''
        Animated Busy Spinners Pack - Titan
      '';
      platform = platforms.all;
    };
  };
  resource-images-backgroundoverlays-basic = mkKodiPlugin {
    plugin = "resource-images-backgroundoverlays-basic";
    namespace = "resource.images.backgroundoverlays.basic";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.backgroundoverlays.basic/resource.images.backgroundoverlays.basic-1.0.0.zip";
      sha256 = "0l3zq8yi7h91194kgkkxv9898rvmp93148p4s2pjgp9lc42p2c2c";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Background Overlays Pack - Basic";
      longDescription = ''
        Pack of images that can be used as background overlay
      '';
      platform = platforms.all;
    };
  };
  resource-images-aspectratio-color = mkKodiPlugin {
    plugin = "resource-images-aspectratio-color";
    namespace = "resource.images.aspectratio.color";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.aspectratio.color/resource.images.aspectratio.color-1.0.0.zip";
      sha256 = "1p7fibc39svzpk464k10rcylbzcrnwyzfz9dfgmaqdplr7m8bd6j";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Media Icons - Aspectratio.Color";
      longDescription = ''
        Media Icons Pack - Aspectratio.Color, made by Devilshura
      '';
      platform = platforms.all;
    };
  };
  resource-images-actorart = mkKodiPlugin {
    plugin = "resource-images-actorart";
    namespace = "resource.images.actorart";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.images.actorart/resource.images.actorart-1.0.0.zip";
      sha256 = "06cjf4pa9bns3zjh22jrz68h6iln27zyg45xyczfh3fwr7qibmq9";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Red Carpet";
      longDescription = ''
        Red Carpet - an actress PNG's resource addon
      '';
      platform = platforms.all;
    };
  };
  metadata-thexem-de = mkKodiPlugin {
    plugin = "metadata-thexem-de";
    namespace = "metadata.thexem.de";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.thexem.de/metadata.thexem.de-1.0.7.zip";
      sha256 = "067vblwybqqy0a0bmlr4w70zmvclwp0b51qwdsniw22wsm5s9zcy";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: XEM";
      longDescription = ''
        TheXEM.de is a site that map episode numbering from multiple sources to their TheTVDB.com counterparts. This scraper let you choose between "scene", AniDB.net and TVRage.com, or the original TheTVDB.com order, as the source for the episode numbering; then fetch the correct data from TheTVDB.com. For more information please visit TheXEM.de
      '';
      platform = platforms.all;
    };
  };
  metadata-port-hu = mkKodiPlugin {
    plugin = "metadata-port-hu";
    namespace = "metadata.port.hu";
    version = "1.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.port.hu/metadata.port.hu-1.0.2.zip";
      sha256 = "09alcvgdn13fz8gaixxc7amgzn61k765xlsslzdjpz83clw4vkd6";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-themoviedb-org # version 2.2.0
      metadata-common-imdb-com # version 2.1.9
    ];
    meta = with lib; {
      description = "Kodi addon: Port.hu";
      longDescription = ''
        Download Movie information from www.port.hu and complete it with information from imdb.com.
        PORT.hu collects its programme information data from official and primary sources such as TV channels, cinemas, theatres and film distributors on the one hand and also creates some of its own content, like reviews of films, photos of concerts, buildings and restaurants as well as videos of theatre performances.The collected data are constantly updated on a 24 hour basis, which makes PORT.hu the most up to date programme information portal.
      '';
      platform = platforms.all;
    };
  };
  metadata-filmweb-pl = mkKodiPlugin {
    plugin = "metadata-filmweb-pl";
    namespace = "metadata.filmweb.pl";
    version = "2.4.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.filmweb.pl/metadata.filmweb.pl-2.4.0.zip";
      sha256 = "1w9j84w7hy9pfyz023gwhj15v8xql2gdk77ar9wjar5r6lmvqcnl";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-themoviedb-org # version 3.1.9
    ];
    meta = with lib; {
      description = "Kodi addon: Filmweb";
      longDescription = ''
        Download Movie information from www.filmweb.pl
      '';
      platform = platforms.all;
    };
  };
  metadata-mtime-com = mkKodiPlugin {
    plugin = "metadata-mtime-com";
    namespace = "metadata.mtime.com";
    version = "1.1.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.mtime.com/metadata.mtime.com-1.1.9.zip";
      sha256 = "1zrbpp078rhknyirwvzmsb3hpiaywmjy0rrfxp1wplr152b35fsn";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: MTime";
      longDescription = ''
        Download Movie information from www.mtime.com. Mtime is the largest movie portal in China. Found in 2004, Mtime provides top four movie services in China: largest movie/TV database in Chinese: largest movie review and rating: the only nationwide movie theater and Showtime search; and the largest movie marketing and promotion services.
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  metadata-filmaffinity-com = mkKodiPlugin {
    plugin = "metadata-filmaffinity-com";
    namespace = "metadata.filmaffinity.com";
    version = "1.9.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.filmaffinity.com/metadata.filmaffinity.com-1.9.5.zip";
      sha256 = "005k9cn25j8ydbgxz9m38kvbk6sxrjdyzpjrkhv5sn4ch4wfihgn";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-themoviedb-org # version 2.9.2
      metadata-common-imdb-com # version 2.7.6
      plugin-video-youtube # version 3.4.4
    ];
    meta = with lib; {
      description = "Kodi addon: FilmAffinity";
      longDescription = ''
        Download Movie information from www.filmaffinity.com
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  metadata-douban-com = mkKodiPlugin {
    plugin = "metadata-douban-com";
    namespace = "metadata.douban.com";
    version = "1.1.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.douban.com/metadata.douban.com-1.1.7.zip";
      sha256 = "0bxc8mkqq42lri0pga0z5wcj2m5l2rgn5zsd4r914a45hig9262a";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-themoviedb-org # version 2.13.1
    ];
    meta = with lib; {
      description = "Kodi addon: douban";
      longDescription = ''
        Download movie information from movie.douban.com
      '';
      homepage = "";
      platform = platforms.all;
    };
  };
  metadata-common-ofdb-de = mkKodiPlugin {
    plugin = "metadata-common-ofdb-de";
    namespace = "metadata.common.ofdb.de";
    version = "1.0.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.ofdb.de/metadata.common.ofdb.de-1.0.5.zip";
      sha256 = "03bxham2qzr75ryy0mz5895ikc1i9c35ghjzk0c22v4s9l7spyrj";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: OFDb.de Scraper Library";
      longDescription = ''
        OFDb.de Scraper Library
      '';
      platform = platforms.all;
    };
  };
  metadata-common-omdbapi-com = mkKodiPlugin {
    plugin = "metadata-common-omdbapi-com";
    namespace = "metadata.common.omdbapi.com";
    version = "1.2.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.omdbapi.com/metadata.common.omdbapi.com-1.2.1.zip";
      sha256 = "06gq0qv3nlvyvw2gyzqz9h7lk5s309mj30al6f86qigiz40ziqyv";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: OMDBAPI common scraper functions";
      longDescription = ''
        Download Rotten Tomato ratings from omdbapi.com
      '';
      platform = platforms.all;
    };
  };
  metadata-common-theaudiodb-com = mkKodiPlugin {
    plugin = "metadata-common-theaudiodb-com";
    namespace = "metadata.common.theaudiodb.com";
    version = "2.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.theaudiodb.com/metadata.common.theaudiodb.com-2.0.3.zip";
      sha256 = "0pkx3plpg6j2aycwaizym08ss24wa9aq40d09wr9gnsvhnry59hy";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: TheAudioDb Scraper Library";
      longDescription = ''
        Download Music information from www.theaudiodb.com
      '';
      platform = platforms.all;
    };
  };
  metadata-common-movie-daum-net = mkKodiPlugin {
    plugin = "metadata-common-movie-daum-net";
    namespace = "metadata.common.movie.daum.net";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.common.movie.daum.net/metadata.common.movie.daum.net-1.0.1.zip";
      sha256 = "1gjd2h46dpbnc4x5fliwg48cb588pswc0cfcklwrbn3xzpbc5y1p";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 1.0
    ];
    meta = with lib; {
      description = "Kodi addon: Daum movie common scraper functions";
      longDescription = ''
        Download movie information from movie.daum.net
      '';
      platform = platforms.all;
    };
  };
  metadata-atmovies-com-tw = mkKodiPlugin {
    plugin = "metadata-atmovies-com-tw";
    namespace = "metadata.atmovies.com.tw";
    version = "1.6.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.atmovies.com.tw/metadata.atmovies.com.tw-1.6.7.zip";
      sha256 = "1lyfc83micxp7x26gpl36gv05rlbxy6sva2sv6c6zhjlv7x7jijr";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-themoviedb-org # version 3.1.0
      metadata-common-imdb-com # version 2.6.0
    ];
    meta = with lib; {
      description = "Kodi addon: AtMovies Movie Scraper";
      longDescription = ''
        AtMovies a free and open movie database in Traditional Chinese. This scraper downloads movie details from AtMovies. Part of the information will be downloaded from IMDB and TMDB..
      '';
      homepage = "http://1somethings.blogspot.tw/search/label/AtMovies";
      platform = platforms.all;
    };
  };
  metadata-artists-xiami-com = mkKodiPlugin {
    plugin = "metadata-artists-xiami-com";
    namespace = "metadata.artists.xiami.com";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.artists.xiami.com/metadata.artists.xiami.com-1.0.0.zip";
      sha256 = "1l5ndvbkxsch1hyvrc02s0f3j36iy8xkbj401w9blk5rqmdipfzs";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: Xiami Artist Scraper";
      longDescription = ''
        Download artist information from xiami.com
      '';
      platform = platforms.all;
    };
  };
  metadata-artists-theaudiodb-com = mkKodiPlugin {
    plugin = "metadata-artists-theaudiodb-com";
    namespace = "metadata.artists.theaudiodb.com";
    version = "1.1.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.artists.theaudiodb.com/metadata.artists.theaudiodb.com-1.1.2.zip";
      sha256 = "0vjvjlw9gnprqhsqy318kmjnqcx9ymqzzdv49yrrsw8msyvfzw3h";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-theaudiodb-com # version 1.7.3
    ];
    meta = with lib; {
      description = "Kodi addon: TheAudioDb Artist Scraper";
      longDescription = ''
        TheAudioDB.com is a community driven database of audio releases. It is our aim to be the most simple, easy to use and accurate source for Music metadata on the web. We also provide an API to access our repository of data so it can be used in many popular HTPC and Mobile apps to give you the best possible audio experience without the hassle.
      '';
      homepage = "http://www.theaudiodb.com/";
      platform = platforms.all;
    };
  };
  metadata-albums-xiami-com = mkKodiPlugin {
    plugin = "metadata-albums-xiami-com";
    namespace = "metadata.albums.xiami.com";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.albums.xiami.com/metadata.albums.xiami.com-1.0.0.zip";
      sha256 = "1ccj2509h3a8xbaaz1kc5isyk0szg7n307whympsd2ii86lz0jnr";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
    ];
    meta = with lib; {
      description = "Kodi addon: Xiami Album Scraper";
      longDescription = ''
        Download album information from xiami.com
      '';
      platform = platforms.all;
    };
  };
  metadata-albums-theaudiodb-com = mkKodiPlugin {
    plugin = "metadata-albums-theaudiodb-com";
    namespace = "metadata.albums.theaudiodb.com";
    version = "1.2.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/metadata.albums.theaudiodb.com/metadata.albums.theaudiodb.com-1.2.3.zip";
      sha256 = "0v3gzs5lywcyfzkd2i4a71ij633pfygdcw08bpc2z93blc1k7aag";
    };
    propagatedBuildInputs = [
      xbmc-metadata # version 2.1.0
      metadata-common-fanart-tv # version 3.1.0
      metadata-common-theaudiodb-com # version 1.7.3
    ];
    meta = with lib; {
      description = "Kodi addon: TheAudioDb Album Scraper";
      longDescription = ''
        TheAudioDB.com is a community driven database of audio releases. It is our aim to be the most simple, easy to use and accurate source for Music metadata on the web. We also provide an API to access our repository of data so it can be used in many popular HTPC and Mobile apps to give you the best possible audio experience without the hassle.
      '';
      homepage = "http://www.theaudiodb.com/";
      platform = platforms.all;
    };
  };
  game-controller-vectrex = mkKodiPlugin {
    plugin = "game-controller-vectrex";
    namespace = "game.controller.vectrex";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.vectrex/game.controller.vectrex-1.0.7.zip";
      sha256 = "08g82vwa17cl443g7vcc39mphccb7drn4mqxx5gzlbfjl3mjqnj5";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Vectrex Controller";
      longDescription = ''
        The Vectrex was released in 1982 by General Consumer Electronics (later purchased by Milton Bradley). The console featured a built-in monochrome monitor capable of displaying vector graphics.
      '';
      platform = platforms.all;
    };
  };
  game-controller-wiimote = mkKodiPlugin {
    plugin = "game-controller-wiimote";
    namespace = "game.controller.wiimote";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.wiimote/game.controller.wiimote-1.0.0.zip";
      sha256 = "0d8zzf6y69snp1ijjpfs51vr02hxyln45rjjacaks7mw1mvsfg4i";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Wii Remote Controller";
      longDescription = ''
        The Wii Remote, also known colloquially as the Wiimote, is the primary game controller for the Nintendo Wii home video game console.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ws = mkKodiPlugin {
    plugin = "game-controller-ws";
    namespace = "game.controller.ws";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ws/game.controller.ws-1.0.8.zip";
      sha256 = "12ri151x2w9gayv5520ims7n0wl1myw5167vmwhaj6p1h0y0dmw5";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: WonderSwan";
      longDescription = ''
        The WonderSwan is a 16-bit handheld console released in 1999 by Bandai. It is playable both vertically and horizontally, and was praised for its long battery life and unique library of games.
      '';
      platform = platforms.all;
    };
  };
  game-controller-snes-mouse = mkKodiPlugin {
    plugin = "game-controller-snes-mouse";
    namespace = "game.controller.snes.mouse";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.snes.mouse/game.controller.snes.mouse-1.0.8.zip";
      sha256 = "12vf5g3mygq1vqn5cgzlkh9sgk0xkwpg0jfn6yja9pv1nkv7jkam";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: SNES Mouse";
      longDescription = ''
        The SNES mouse was first released in 1992. It was originally designed for use with the game Mario Paint.
      '';
      platform = platforms.all;
    };
  };
  game-controller-snes-multitap = mkKodiPlugin {
    plugin = "game-controller-snes-multitap";
    namespace = "game.controller.snes.multitap";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.snes.multitap/game.controller.snes.multitap-1.0.8.zip";
      sha256 = "1438sq2kaiwdxvjz7qrv3v5463jil724kk4vjkb5d72cl0s6xwkd";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Super Multitap";
      longDescription = ''
        A multitap increases the number of controller ports, similar to a USB hub. The Super Multitap was released by Hudson Soft in 1993 for use with the Bomberman games.
      '';
      platform = platforms.all;
    };
  };
  game-controller-snes-super-scope = mkKodiPlugin {
    plugin = "game-controller-snes-super-scope";
    namespace = "game.controller.snes.super.scope";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.snes.super.scope/game.controller.snes.super.scope-1.0.8.zip";
      sha256 = "06gqrk47f3viwnafkbiypfrchwwz342hahr76ks39ajzn5ss34lp";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Super Scope";
      longDescription = ''
        The Super Scope is a light gun for the SNES. It was released in 1992 as a successor to the NES Zapper.
      '';
      platform = platforms.all;
    };
  };
  game-controller-vb = mkKodiPlugin {
    plugin = "game-controller-vb";
    namespace = "game.controller.vb";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.vb/game.controller.vb-1.0.8.zip";
      sha256 = "1yjkziq133zdqkbpldy3qc6i0cqz9icwr2b6ldk16aizzsanp93w";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Nintendo Virtual Boy Controller";
      longDescription = ''
        The Virtual Boy is a 32-bit console released by Nintendo in 1995. While Nintendo promised a virtual reality experience, the red monochrome display and bulky table-mounted headset lead to a poor immersive experience.
      '';
      platform = platforms.all;
    };
  };
  game-controller-sg1000 = mkKodiPlugin {
    plugin = "game-controller-sg1000";
    namespace = "game.controller.sg1000";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.sg1000/game.controller.sg1000-1.0.8.zip";
      sha256 = "1nwmgjy4jd49gcdg9p92cbyj2108mlcin9rywal3y6p2c1pm621l";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega SG-1000 Controller";
      longDescription = ''
        The SG-1000, also known as the Computer Videogame SG-1000, was Sega's first entry into the console business in 1983. However, due to market saturation and the Video Game Crash of 1983, it was not commercially successful.
      '';
      platform = platforms.all;
    };
  };
  game-controller-sms = mkKodiPlugin {
    plugin = "game-controller-sms";
    namespace = "game.controller.sms";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.sms/game.controller.sms-1.0.8.zip";
      sha256 = "15mv3c5w5kyg4kn7rmsxj4jq1c3zdpqf93h3m6s6z0pdalhcmvyn";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Master System Controller";
      longDescription = ''
        The Master System, originally named the Mark III, was released by Sega in 1985. As of 2015, the Master System is the longest-lived game console due to its surging popularity in Brazil.
      '';
      platform = platforms.all;
    };
  };
  game-controller-snes = mkKodiPlugin {
    plugin = "game-controller-snes";
    namespace = "game.controller.snes";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.snes/game.controller.snes-1.0.8.zip";
      sha256 = "1s23pp3v3sg2q9yj937m0w4bw969hxd0hbc1hz47s8kp4v0dq3rq";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: SNES Controller";
      longDescription = ''
        The SNES (akso known as Super NES or Super Nintendo) is a 16-bit console released in 1990. The controller design served as inspiration for the PlayStation, Dreamcast, Xbox and Wii Classic controllers.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-virtua-gun-us = mkKodiPlugin {
    plugin = "game-controller-saturn-virtua-gun-us";
    namespace = "game.controller.saturn.virtua.gun.us";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.virtua.gun.us/game.controller.saturn.virtua.gun.us-1.0.8.zip";
      sha256 = "19nn0nkj8wwzvdy07x82mxras2p76s2grnpkr8dvnm5vrfadydwq";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Virtua Gun (US)";
      longDescription = ''
        The Virtua Gun was released for the Sega Saturn in 1995. Bright colors were used for western models due to fears that it could be linked with gun crime.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-virtua-gun-eu = mkKodiPlugin {
    plugin = "game-controller-saturn-virtua-gun-eu";
    namespace = "game.controller.saturn.virtua.gun.eu";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.virtua.gun.eu/game.controller.saturn.virtua.gun.eu-1.0.8.zip";
      sha256 = "0byw80bv5nxrwlb8sfc9ldi131rn27d80jqv3lalyja2xfkwidi5";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Virtua Gun (Eurpoean)";
      longDescription = ''
        The Virtua Gun was released for the Sega Saturn in 1995. Bright colors were used for western models due to fears that it could be linked with gun crime.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-virtua-gun-japan = mkKodiPlugin {
    plugin = "game-controller-saturn-virtua-gun-japan";
    namespace = "game.controller.saturn.virtua.gun.japan";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.virtua.gun.japan/game.controller.saturn.virtua.gun.japan-1.0.7.zip";
      sha256 = "0ibjkn57j0pjpggbzin92zkbrgqs8q0zwa4h506qg0qd38llz4lh";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Virtua Gun (Japan)";
      longDescription = ''
        The Virtua Gun was released for the Sega Saturn in 1995. Bright colors were used for western models due to fears that it could be linked with gun crime.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-mouse = mkKodiPlugin {
    plugin = "game-controller-saturn-mouse";
    namespace = "game.controller.saturn.mouse";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.mouse/game.controller.saturn.mouse-1.0.8.zip";
      sha256 = "0cqsjc3m737gnf1nl2df6jks62gmk6p2d0kwwnwfmhmdq7cyszx8";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Shuttle Mouse";
      longDescription = ''
        The Shuttle Mouse, released in 1994, is an official mouse peripheral for the Sega Saturn. It was designed to be used with simulation-oriented games
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-multitap = mkKodiPlugin {
    plugin = "game-controller-saturn-multitap";
    namespace = "game.controller.saturn.multitap";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.multitap/game.controller.saturn.multitap-1.0.9.zip";
      sha256 = "1h014yxppgkmx6js49xk4s2r50anicqy4g5x77jdhn803fsk488a";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Saturn 6 Player Adaptor";
      longDescription = ''
        A multitap increases the number of controller ports, similar to a USB hub. Released in 1995, the Saturn 6 Player Adaptor allowed up to 10 players in some games, such as Saturn Bomberman.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-twin-stick = mkKodiPlugin {
    plugin = "game-controller-saturn-twin-stick";
    namespace = "game.controller.saturn.twin.stick";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.twin.stick/game.controller.saturn.twin.stick-1.0.8.zip";
      sha256 = "0fry74z4bskpq2hyprsmww7a27v0w6fx319pd89cysck0h22qg4j";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Twin Stick";
      longDescription = ''
        The Sega Twin Stick, released in 1996, features two joysticks at the expense of fewer buttons. It was designed for the game Cyber Troopers Virtual-On.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-mission-stick = mkKodiPlugin {
    plugin = "game-controller-saturn-mission-stick";
    namespace = "game.controller.saturn.mission.stick";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.mission.stick/game.controller.saturn.mission.stick-1.0.8.zip";
      sha256 = "07cd7rg3ip57c9nw5v70q6ssn09wszz8ds195qqkv9yrqp8cnskx";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Mission Stick";
      longDescription = ''
        The Sega Mission Stick is a fight stick for the Sega Saturn released in 1995. A second stick could be connected to allow twin sticks in Panzer Dragoon Zwei.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-mission-sticks = mkKodiPlugin {
    plugin = "game-controller-saturn-mission-sticks";
    namespace = "game.controller.saturn.mission.sticks";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.mission.sticks/game.controller.saturn.mission.sticks-1.0.8.zip";
      sha256 = "0riwf1h726i11ms3lgvr47r83jz12mscwa8f07gaz4xkg19slajx";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Mission Sticks";
      longDescription = ''
        The Sega Mission Stick is a fight stick for the Sega Saturn released in 1995. A second stick could be connected to allow twin sticks in Panzer Dragoon Zwei.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-arcade-racer = mkKodiPlugin {
    plugin = "game-controller-saturn-arcade-racer";
    namespace = "game.controller.saturn.arcade.racer";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.arcade.racer/game.controller.saturn.arcade.racer-1.0.8.zip";
      sha256 = "111h4zxijw380i8r93xwr4zhb3yiqgm3p5wzqqh400krw28x1gcs";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Arcade Racer";
      longDescription = ''
        The Arcade Racer, released in 1995, is a racing wheel style controller for the Sega Saturn.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-3d-japan = mkKodiPlugin {
    plugin = "game-controller-saturn-3d-japan";
    namespace = "game.controller.saturn.3d.japan";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.3d.japan/game.controller.saturn.3d.japan-1.0.8.zip";
      sha256 = "0k330h7a149qma06bcj6hw4qhc8pici9cygjp8hwd9998ggn4c3d";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Saturn 3D (Japan)";
      longDescription = ''
        The Sega Saturn 3D Control Pad was released in 1996. It was Sega's answer to the revolutionary Nintendo 64 controller, which featured an analogue stick for greater precision in a 3D environment.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn-3d-western = mkKodiPlugin {
    plugin = "game-controller-saturn-3d-western";
    namespace = "game.controller.saturn.3d.western";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn.3d.western/game.controller.saturn.3d.western-1.0.8.zip";
      sha256 = "16919i7qh1v1bsdbc6cyrr54rggpqza58hm0pxi8wzlzb4grpwli";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Saturn 3D (Western)";
      longDescription = ''
        The Sega Saturn 3D Control Pad was released in 1996. It was Sega's answer to the revolutionary Nintendo 64 controller, which featured an analogue stick for greater precision in a 3D environment.
      '';
      platform = platforms.all;
    };
  };
  game-controller-saturn = mkKodiPlugin {
    plugin = "game-controller-saturn";
    namespace = "game.controller.saturn";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.saturn/game.controller.saturn-1.0.7.zip";
      sha256 = "1vgxm0v67inskvpj6mbw365sinw0pplrlx43m168jn8l3dxplpc3";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Saturn Controller";
      longDescription = ''
        The original controller for the Sega Saturn debuted in Japan in 1994. In North America and Europe, a different, much bulkier controller was released to supposedly accommodate for the "bigger hands" of western consumers.
      '';
      platform = platforms.all;
    };
  };
  game-controller-psp = mkKodiPlugin {
    plugin = "game-controller-psp";
    namespace = "game.controller.psp";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.psp/game.controller.psp-1.0.9.zip";
      sha256 = "093vs12sa73ki3mj215i5acd2xvmgnipqaifck4lwqirifv04scg";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PSP";
      longDescription = ''
        The PlayStation Portable (PSP) was released by Sony in 2004. It was praised for its high-end GPU and bright 4.3 inch screen. The PSP was succeeded by the PSP Go in 2009, and then the PlayStation Vita in 2011.
      '';
      platform = platforms.all;
    };
  };
  game-controller-remote = mkKodiPlugin {
    plugin = "game-controller-remote";
    namespace = "game.controller.remote";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.remote/game.controller.remote-1.0.7.zip";
      sha256 = "014f6iq7n2k355rwwx25440smb672hf5q27ln3sk2ps2pm32b8mz";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: TV Remote";
      longDescription = ''
        A TV remote with basic navigational capabilities.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-mouse = mkKodiPlugin {
    plugin = "game-controller-ps-mouse";
    namespace = "game.controller.ps.mouse";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.mouse/game.controller.ps.mouse-1.0.8.zip";
      sha256 = "0arf9p2dhg09qsp9c2908y30k0wby4wyqx266cfkh57sbfmxajfh";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Mouse";
      longDescription = ''
        The PlayStation Mouse is a two-button ball mouse. It was released alongside the PlayStation in 1994.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-multitap = mkKodiPlugin {
    plugin = "game-controller-ps-multitap";
    namespace = "game.controller.ps.multitap";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.multitap/game.controller.ps.multitap-1.0.9.zip";
      sha256 = "0sgxdzpxg9ylwhhw0dmdlh17zn9asprg62yg15ld7qg7hjjn32zz";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Multitap";
      longDescription = ''
        A multitap increases the number of controller and memory card ports, similar to a USB hub. With a second PlayStation Multitap, up to eight controllers and memory cards can be plugged in at once.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-dualshock = mkKodiPlugin {
    plugin = "game-controller-ps-dualshock";
    namespace = "game.controller.ps.dualshock";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.dualshock/game.controller.ps.dualshock-1.0.8.zip";
      sha256 = "04pvz88xrg9ww84gvnw2759iinmw3qyabv01v4w4vvzdhb5qj0ar";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation DualShock";
      longDescription = ''
        The PlayStation Controller was released by Sony Computer Entertainment in 1994. Sony briefly released the Dual Analog controller in 1997, followed by the rumble-enabled DualShock later that year.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-dualanalog = mkKodiPlugin {
    plugin = "game-controller-ps-dualanalog";
    namespace = "game.controller.ps.dualanalog";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.dualanalog/game.controller.ps.dualanalog-1.0.8.zip";
      sha256 = "0n5bkc78fr2d75wq3l0kbi0x512m86qwfdw1235jynn1q3iwahyg";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Dual Analog";
      longDescription = ''
        The PlayStation Controller was released by Sony Computer Entertainment in 1994. Sony briefly released the Dual Analog controller in 1997, followed by the rumble-enabled DualShock later that year.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-gamepad = mkKodiPlugin {
    plugin = "game-controller-ps-gamepad";
    namespace = "game.controller.ps.gamepad";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.gamepad/game.controller.ps.gamepad-1.0.9.zip";
      sha256 = "1wswv1ri3xzfwxkf6rn96ac58k9pmwjw30pycwwjl29i9ckkdqyv";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Gamepad";
      longDescription = ''
        The PlayStation controller was released by Sony Computer Entertainment in 1994. Sony briefly released the Dual Analog controller in 1997, followed by the rumble-enabled DualShock later that year.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-guncon-japan = mkKodiPlugin {
    plugin = "game-controller-ps-guncon-japan";
    namespace = "game.controller.ps.guncon.japan";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.guncon.japan/game.controller.ps.guncon.japan-1.0.8.zip";
      sha256 = "1ncin5g9c26pgcr74bpp56x2nwi70kq4plbmh6whkqgmkbqq5vmz";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Guncon (Japan)";
      longDescription = ''
        The Guncon, known as G-Con in Europe, is a family of light guns designed by Namco for the PlayStation. The original model was released alongside the PlayStation in 1994.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps-guncon-western = mkKodiPlugin {
    plugin = "game-controller-ps-guncon-western";
    namespace = "game.controller.ps.guncon.western";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps.guncon.western/game.controller.ps.guncon.western-1.0.8.zip";
      sha256 = "1y4wvfhfpzl5y4clp4m8q8d5pxy0gy3k7mqgvpxyc5ifr2pysvk7";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Guncon (Western)";
      longDescription = ''
        The Guncon, known as G-Con in Europe, is a family of light guns designed by Namco for the PlayStation. The original model was released alongside the PlayStation in 1994.
      '';
      platform = platforms.all;
    };
  };
  game-controller-pokemini = mkKodiPlugin {
    plugin = "game-controller-pokemini";
    namespace = "game.controller.pokemini";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.pokemini/game.controller.pokemini-1.0.0.zip";
      sha256 = "0yqfrwv8gljphl45malvkxm3b43i1jaz7zrgiy65s7sqy6ryn05q";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Pokémini Controller";
      longDescription = ''
        The Pokémon Mini is a handheld game console that was designed and manufactured by Nintendo and themed around the Pokémon media franchise. It is the smallest game system with interchangeable cartridges ever produced by Nintendo, weighing just under two and a half ounces (71 grams).
      '';
      platform = platforms.all;
    };
  };
  game-controller-ps = mkKodiPlugin {
    plugin = "game-controller-ps";
    namespace = "game.controller.ps";
    version = "1.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ps/game.controller.ps-1.0.6.zip";
      sha256 = "1g7ipcnciny2xm79d8l6lyg0ygckg4292sjb87a1hppxnca9rmi8";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PlayStation Controller";
      longDescription = ''
        The PlayStation Controller was released by Sony Computer Entertainment in 1994.
      '';
      platform = platforms.all;
    };
  };
  game-controller-pcfx-mouse = mkKodiPlugin {
    plugin = "game-controller-pcfx-mouse";
    namespace = "game.controller.pcfx.mouse";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.pcfx.mouse/game.controller.pcfx.mouse-1.0.9.zip";
      sha256 = "0dzcrzc5v6qz7f2qxfq9zgvvg6jxjinrg3m4q6hkmcfvca4mrxfg";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PC-FX Mouse";
      longDescription = ''
        The PC-FX mouse is a two-button ball mouse released in 1994. It is supported by strategy games like Farland Story FX and Power DoLLS FX.
      '';
      platform = platforms.all;
    };
  };
  game-controller-pcfx = mkKodiPlugin {
    plugin = "game-controller-pcfx";
    namespace = "game.controller.pcfx";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.pcfx/game.controller.pcfx-1.0.8.zip";
      sha256 = "02bj8hzg04x8ln4ynp8w1ry9f8rra6nmi4xb7mb6wh6vxbzjpbqk";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PC-FX Controller";
      longDescription = ''
        The PC-FX is a 32-bit console released by NEC in 1994. Due to the high cost, underpowered graphics and lack of developer support, it sold poorly and was discontinued in 1998.
      '';
      platform = platforms.all;
    };
  };
  game-controller-pce = mkKodiPlugin {
    plugin = "game-controller-pce";
    namespace = "game.controller.pce";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.pce/game.controller.pce-1.0.8.zip";
      sha256 = "01ziwq78pfrmxrwypzbqfwpgwh7m9a07s14n483kfv0qmsr1ihbs";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PC Engine Controller";
      longDescription = ''
        The PC Engine, also known as the TurboGrafx-16, was released by Hudson Soft and NEC in 1987. It became the top-selling console in Japan, but trailed behind both Sega and Nintendo in the North American and Eurpoean markets.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ouya = mkKodiPlugin {
    plugin = "game-controller-ouya";
    namespace = "game.controller.ouya";
    version = "1.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ouya/game.controller.ouya-1.0.1.zip";
      sha256 = "1wgad1k1ikxv75rg5r4hldalp2si066gxgyrzy1ijlbzp5nhr7fz";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: OUYA Controller";
      longDescription = ''
        The OUYA is a crowd-funded Android-based microconsole released in 2013. The OUYA controller includes a single-touch touchpad in the center of the controller.
      '';
      platform = platforms.all;
    };
  };
  game-controller-nds = mkKodiPlugin {
    plugin = "game-controller-nds";
    namespace = "game.controller.nds";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.nds/game.controller.nds-1.0.7.zip";
      sha256 = "02rfnra7f9qn7mkyh26s3kk0pn3xq98cnynsnqcypsq5gqnjm502";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Nintendo DS";
      longDescription = ''
        The Nintendo DS (short for "Dual Screen") is a 32-bit handheld video game console released in 2004. A DS Lite model was launched in 2006, followed by the DSi. Combined, these are the best selling handheld to date, and second best console (behind the PlayStation 2).
      '';
      platform = platforms.all;
    };
  };
  game-controller-nes-four-score = mkKodiPlugin {
    plugin = "game-controller-nes-four-score";
    namespace = "game.controller.nes.four.score";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.nes.four.score/game.controller.nes.four.score-1.0.9.zip";
      sha256 = "1vy34lgb6wlzkxmsw4kg2pm0i4bhlfa2bjbx5rwq7lbwmikbm6nd";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: NES Four Score";
      longDescription = ''
        The NES Four Score is a multitap accessory created by Nintendo in 1990. It allows for four-player gameplay.
      '';
      platform = platforms.all;
    };
  };
  game-controller-nes = mkKodiPlugin {
    plugin = "game-controller-nes";
    namespace = "game.controller.nes";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.nes/game.controller.nes-1.0.8.zip";
      sha256 = "19sww5ly1m00lq5by2scnl6f9lw25q6dqcdv3k750ykxfplzpdyl";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: NES Controller";
      longDescription = ''
        The Nintendo Entertainment System, also known as the Famicom (for "Family Computer"), was released in 1983. The cross-shaped directional pad was designed for Game & Watch systems, replacing the bulkier joysticks found on earlier controllers.
      '';
      platform = platforms.all;
    };
  };
  game-controller-ngp = mkKodiPlugin {
    plugin = "game-controller-ngp";
    namespace = "game.controller.ngp";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.ngp/game.controller.ngp-1.0.8.zip";
      sha256 = "1lyabq28kldp2zsg0lbbw8mhldsc7cyk5wzl8fyghpq7fiyxlp6i";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Neo Geo Pocket";
      longDescription = ''
        The Neo Geo Pocket was a handheld console with a monochrome screen released by SNK in 1998. It was generally unsuccessful and in 1999 was replaced by the Neo Geo Pocket Color to better compete with the Game Boy Color.
      '';
      platform = platforms.all;
    };
  };
  game-controller-odyssey2 = mkKodiPlugin {
    plugin = "game-controller-odyssey2";
    namespace = "game.controller.odyssey2";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.odyssey2/game.controller.odyssey2-1.0.8.zip";
      sha256 = "0ps9l3mhcsrhlw3hnyw0fbcscv64gip0vgqz4f9ba42r91lgdrrc";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Odyssey2 Controller";
      longDescription = ''
        The Odyssey², also known as the Videopac G7000, was released by Magnavox (now Philips) in 1978. All games produced by Magnavox/Philips ended with an exclamation point, such as K.C. Munchkin! and Kuller Bees!.
      '';
      platform = platforms.all;
    };
  };
  game-controller-n64 = mkKodiPlugin {
    plugin = "game-controller-n64";
    namespace = "game.controller.n64";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.n64/game.controller.n64-1.0.8.zip";
      sha256 = "1fvn8h634yrm7wv6zf6lisrbsxdl8rm9sjqs03qi7fcym0s88czs";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Nintendo 64 Controller";
      longDescription = ''
        The Nintendo 64 controller, released in 1996, featured a unique "M" shape design. Intense rotating of the analog stick during Mario Party reportedly caused burn injuries to some players.
      '';
      platform = platforms.all;
    };
  };
  game-controller-msx-joystick = mkKodiPlugin {
    plugin = "game-controller-msx-joystick";
    namespace = "game.controller.msx.joystick";
    version = "1.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.msx.joystick/game.controller.msx.joystick-1.0.3.zip";
      sha256 = "1wd3fxyiz0qllrnb0gmxg91zimnl28fmhg0bpmrq0nvr30lpw8li";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: MSX Joystick";
      longDescription = ''
        The MSX joystick featured A and B buttons and four-way directional control.
      '';
      platform = platforms.all;
    };
  };
  game-controller-msx-keyboard = mkKodiPlugin {
    plugin = "game-controller-msx-keyboard";
    namespace = "game.controller.msx.keyboard";
    version = "1.0.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.msx.keyboard/game.controller.msx.keyboard-1.0.4.zip";
      sha256 = "1q1hdiz2vasdsgjmswbhai2yklxwdrgbhcjy6s069yjkz53cs459";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: MSX Keyboard";
      longDescription = ''
        The MSX keyboard came in internal and external units. One troubleshooting hint when an MSX machine does not display an image is to press the CAPS key repeatedly to see if the LED toggles.
      '';
      platform = platforms.all;
    };
  };
  game-controller-mouse = mkKodiPlugin {
    plugin = "game-controller-mouse";
    namespace = "game.controller.mouse";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.mouse/game.controller.mouse-1.0.9.zip";
      sha256 = "0nx70vajkizv6i19j0l7ns56s8s0didbw0c9pdni6mjy147xj15v";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Computer Mouse";
      longDescription = ''
        A standard mouse with two buttons and a middle wheel.
      '';
      platform = platforms.all;
    };
  };
  game-controller-joystick-2button = mkKodiPlugin {
    plugin = "game-controller-joystick-2button";
    namespace = "game.controller.joystick.2button";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.joystick.2button/game.controller.joystick.2button-1.0.9.zip";
      sha256 = "0hd756f4h0l4ldi579a715bhgmqnpd0a57d0wlm6v605v5p96i5m";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PC Joystick (2-Button)";
      longDescription = ''
        The 2-button joystick was compatible with the Game Port, a device port found on IBM PCs throughout the 1980s and 1990s.
      '';
      platform = platforms.all;
    };
  };
  game-controller-joystick-4button = mkKodiPlugin {
    plugin = "game-controller-joystick-4button";
    namespace = "game.controller.joystick.4button";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.joystick.4button/game.controller.joystick.4button-1.0.9.zip";
      sha256 = "1p5qz5pdnxf67qx8vl653k9n8rwcnlcgdnazzxgcy3njd3mrpq7y";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: PC Joystick (4-Button)";
      longDescription = ''
        The 4-button joystick was compatible with the Game Port, a device port found on IBM PCs throughout the 1980s and 1990s.
      '';
      platform = platforms.all;
    };
  };
  game-controller-keyboard = mkKodiPlugin {
    plugin = "game-controller-keyboard";
    namespace = "game.controller.keyboard";
    version = "1.1.5";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.keyboard/game.controller.keyboard-1.1.5.zip";
      sha256 = "141w21nj4yhhd5s4kipshfx1kq173k8vfgzfbpfc9250knw3vvm9";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: IMB Model M Keyboard";
      longDescription = ''
        The IMB Model M keyboard, introduced in 1984, is regarded as a timeless and durable piece of hardware.
      '';
      platform = platforms.all;
    };
  };
  game-controller-konami-justifier-player2 = mkKodiPlugin {
    plugin = "game-controller-konami-justifier-player2";
    namespace = "game.controller.konami.justifier.player2";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.konami.justifier.player2/game.controller.konami.justifier.player2-1.0.9.zip";
      sha256 = "1sjgca5nrh0ma6hbm1zbnihrv65avmh60dpac8v120fgxhq173cb";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Konami Justifier (Player 2)";
      longDescription = ''
        The Justifer is a light gun released by Konami in 1992 for the Sega Mega Drive/Genesis, SNES and PlayStation. It resembles the Colt Python, a .357 Magnum revolver.
      '';
      platform = platforms.all;
    };
  };
  game-controller-konami-justifier-ps = mkKodiPlugin {
    plugin = "game-controller-konami-justifier-ps";
    namespace = "game.controller.konami.justifier.ps";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.konami.justifier.ps/game.controller.konami.justifier.ps-1.0.9.zip";
      sha256 = "1wi0h47mcg0c5i4ynhbd237zxdrvqv9jwz7a0nklyaa75nfhx6fb";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Konami Justifier (PS)";
      longDescription = ''
        The Justifer is a light gun released by Konami in 1992 for the Sega Mega Drive/Genesis, SNES and PlayStation. It resembles the Colt Python, a .357 Magnum revolver.
      '';
      platform = platforms.all;
    };
  };
  game-controller-konami-justifier-snes = mkKodiPlugin {
    plugin = "game-controller-konami-justifier-snes";
    namespace = "game.controller.konami.justifier.snes";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.konami.justifier.snes/game.controller.konami.justifier.snes-1.0.9.zip";
      sha256 = "0r25p80577y6y3c3zvq05xyfg3dn8ffd6a4jx8mdjjiwz4amd0bl";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Konami Justifier (SNES)";
      longDescription = ''
        The Justifer is a light gun released by Konami in 1992 for the Sega Mega Drive/Genesis, SNES and PlayStation. It resembles the Colt Python, a .357 Magnum revolver.
      '';
      platform = platforms.all;
    };
  };
  game-controller-genesis-6button = mkKodiPlugin {
    plugin = "game-controller-genesis-6button";
    namespace = "game.controller.genesis.6button";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.genesis.6button/game.controller.genesis.6button-1.0.8.zip";
      sha256 = "17fmgm32r6zzfp6nksjplhazb5kw28f37mxb5gl3npw3dnv2gw2r";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Genesis Controller";
      longDescription = ''
        The original controller for the Sega Genesis was released in 1988. It had three main face buttons. Sega released a six-button version in 1993.
      '';
      platform = platforms.all;
    };
  };
  game-controller-genesis-mouse = mkKodiPlugin {
    plugin = "game-controller-genesis-mouse";
    namespace = "game.controller.genesis.mouse";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.genesis.mouse/game.controller.genesis.mouse-1.0.8.zip";
      sha256 = "00wra40314qi9kw9a1ljw5k1wb6p269l1sc902fjmf7ls7fqsw8k";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Mouse";
      longDescription = ''
        The Sega Mouse is a ball mouse for the Sega Mega Drive/Genesis released in 1993. It was intended to be used for art creation software.
      '';
      platform = platforms.all;
    };
  };
  game-controller-genesis = mkKodiPlugin {
    plugin = "game-controller-genesis";
    namespace = "game.controller.genesis";
    version = "1.0.6";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.genesis/game.controller.genesis-1.0.6.zip";
      sha256 = "02wd500bpprp7v2fraz2fifwmqywm5br01nq8jja1xiylcc4d1mb";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Genesis Controller";
      longDescription = ''
        The original Sega Genesis controller had three main face buttons. Sega released a six-button version in 1993.
      '';
      platform = platforms.all;
    };
  };
  game-controller-gravis-gamepad = mkKodiPlugin {
    plugin = "game-controller-gravis-gamepad";
    namespace = "game.controller.gravis.gamepad";
    version = "1.1.4";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.gravis.gamepad/game.controller.gravis.gamepad-1.1.4.zip";
      sha256 = "0pd6rx3k9y5xvbnh009glywcdzl0w6n1c764wh74lyd558ik5zvm";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Gravis PC Gamepad";
      longDescription = ''
        The Gravis gamepad is a controller produced by Advanced Gravis Computer Technology in 1991. It was the first gamepad for the IBM PC in a market dominated by joysticks.
      '';
      platform = platforms.all;
    };
  };
  game-controller-intellivision = mkKodiPlugin {
    plugin = "game-controller-intellivision";
    namespace = "game.controller.intellivision";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.intellivision/game.controller.intellivision-1.0.7.zip";
      sha256 = "10kx4m3faiy6jqgfm5hqd54pg38v1pvp8bvydm5ssmmjhn5ijvg7";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Intellivision Controller";
      longDescription = ''
        The Intellivision, a portmanteau of "intelligent television", was released by Mattel Electronics in 1979. In 2009, IGN named the Intellivision the 14th greatest console of all time.
      '';
      platform = platforms.all;
    };
  };
  game-controller-gamecube = mkKodiPlugin {
    plugin = "game-controller-gamecube";
    namespace = "game.controller.gamecube";
    version = "1.0.0";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.gamecube/game.controller.gamecube-1.0.0.zip";
      sha256 = "0nzwy9y1rjckz2br30y7phy97pn3j75k7vysf3ccw5wk7kmcljkv";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Nintendo GameCube Controller";
      longDescription = ''
        The Nintendo GameCube controller was released in 2001. The analog sticks and triggers were the target of a patent lawsuit, but Nintendo fought back and successfully won the case.
      '';
      platform = platforms.all;
    };
  };
  game-controller-gamegear = mkKodiPlugin {
    plugin = "game-controller-gamegear";
    namespace = "game.controller.gamegear";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.gamegear/game.controller.gamegear-1.0.8.zip";
      sha256 = "1ij61wwr0jq4adh6fpylgfrnkm1zbwnrmq8wn8l6pavf50rs5wic";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Sega Game Gear";
      longDescription = ''
        The Sega Game Gear is an 8-bit handheld video game console released in 1990. While it had a full-color backlit screen and fast processor, the battery life and large size were often criticized.
      '';
      platform = platforms.all;
    };
  };
  game-controller-gba = mkKodiPlugin {
    plugin = "game-controller-gba";
    namespace = "game.controller.gba";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.gba/game.controller.gba-1.0.8.zip";
      sha256 = "19z140gz9cz38dv7ya553q73yiwv8r6f3s6mzxj7n5779zr969ij";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Game Boy Advance";
      longDescription = ''
        The Nintendo Game Boy Advance is a 32-bit handheld video game console released in 2001. Despite fierce competition, Nintendo maintained a majority market share with the device.
      '';
      platform = platforms.all;
    };
  };
  game-controller-dreamcast = mkKodiPlugin {
    plugin = "game-controller-dreamcast";
    namespace = "game.controller.dreamcast";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.dreamcast/game.controller.dreamcast-1.0.9.zip";
      sha256 = "0my7swmc4hnx99gfzmms32z9031kkdlh3z0a2sp1jqarimlxb064";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Dreamcast Controller";
      longDescription = ''
        The Sega Dreamcast was released in 1998. The inclusion of an analog stick reflected the transition from 2D arcade games to 3D game environments. The Dreamcast had a short lifespan and marked the end of Sega's 18 years in the console market.
      '';
      platform = platforms.all;
    };
  };
  game-controller-gameboy = mkKodiPlugin {
    plugin = "game-controller-gameboy";
    namespace = "game.controller.gameboy";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.gameboy/game.controller.gameboy-1.0.8.zip";
      sha256 = "0yagzfqnxqdk42zxyrfnyxl9hgml34wz460z2kqypmj8gkrvkwpi";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Game Boy";
      longDescription = ''
        The Nintendo Game Boy is an 8-bit handheld video game console released in 1989. It became a tremendous success, and in 2009 was inducted into the National Toy Hall of Fame.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-xges-xg1 = mkKodiPlugin {
    plugin = "game-controller-atari-xges-xg1";
    namespace = "game.controller.atari.xges.xg1";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.xges.xg1/game.controller.atari.xges.xg1-1.0.7.zip";
      sha256 = "00fp3pi76fcxsf0mgxfvf1avi432ysqnbsiylk5d3zjidyqyhrs8";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari XG-1 Lightgun";
      longDescription = ''
        The Atari XG-1 is the light gun that came bundled with the Atari XEGS, a game console released in 1987. Many users complained of the horrible accuracy of the device.
      '';
      platform = platforms.all;
    };
  };
  game-controller-colecovision = mkKodiPlugin {
    plugin = "game-controller-colecovision";
    namespace = "game.controller.colecovision";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.colecovision/game.controller.colecovision-1.0.8.zip";
      sha256 = "11p47a7riky2mq3r90bng384z1gwzl41c96slhy4dxi25k8i55n6";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: ColecoVision Controller";
      longDescription = ''
        The ColecoVision is Coleco Industries' second-generation game console, released in 1982. IGN named it the 12th-best console, citing its accuracy in bringing arcade games to the home.
      '';
      platform = platforms.all;
    };
  };
  game-controller-default = mkKodiPlugin {
    plugin = "game-controller-default";
    namespace = "game.controller.default";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.default/game.controller.default-1.0.8.zip";
      sha256 = "0bd59b4gjpajajfhv9czarvpbw0rvi0hj8kgikwp4ahh62q4vfhp";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Default Controller";
      longDescription = ''
        The default media center controller is based on the Xbox 360 controller.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-7800-gamepad = mkKodiPlugin {
    plugin = "game-controller-atari-7800-gamepad";
    namespace = "game.controller.atari.7800.gamepad";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.7800.gamepad/game.controller.atari.7800.gamepad-1.0.9.zip";
      sha256 = "120zv69av9nbs09ssl8xj8gdmhzlfs75ambxhc81nlqj5z4c51y8";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari 7800 Gamepad";
      longDescription = ''
        The Atari 7800 ProSystem was released in 1986. It came bundled with the Atari Proline Joystick, but due to criticism over ergonimic issues Atari later released a gamepad with European 7800s.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-7800-proline = mkKodiPlugin {
    plugin = "game-controller-atari-7800-proline";
    namespace = "game.controller.atari.7800.proline";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.7800.proline/game.controller.atari.7800.proline-1.0.9.zip";
      sha256 = "19id9bf522k9qmgqx1f42k7s0jyvzz4f25bzfzh2j75r6383wf17";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari 7800 Proline";
      longDescription = ''
        The Atari 7800 ProSystem was released in 1986. It came bundled with the Atari Proline Joystick, but due to criticism over ergonimic issues Atari later released a gamepad with European 7800s.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-lynx = mkKodiPlugin {
    plugin = "game-controller-atari-lynx";
    namespace = "game.controller.atari.lynx";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.lynx/game.controller.atari.lynx-1.0.8.zip";
      sha256 = "1qpamf4k1r3dy8js1xg4az3vp2gyk36s5llrmmwj9500pcsw3riv";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari Lynx";
      longDescription = ''
        The Atari Lynx is a 16-bit handheld gaming console released in 1989.  It held notable accomplishments, including the first handheld with a color LCD, advanced graphics, and ambidextrous layout. However, it was a commercial failure and discontinued in 1995.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-xges-keyboard = mkKodiPlugin {
    plugin = "game-controller-atari-xges-keyboard";
    namespace = "game.controller.atari.xges.keyboard";
    version = "1.0.7";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.xges.keyboard/game.controller.atari.xges.keyboard-1.0.7.zip";
      sha256 = "1dgqfz0gbw3a5sx2bsgfmlmb455x7kczipw0x7nnzdv18jyc74aa";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari XGES Keyboard";
      longDescription = ''
        The Atari XGES keyboard was included in the Atari XGES deluxe set, which was released in 1987 by Atari Corporation. Because a keyboard was included, the XGES had home computer functionality.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-2600 = mkKodiPlugin {
    plugin = "game-controller-atari-2600";
    namespace = "game.controller.atari.2600";
    version = "1.1.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.2600/game.controller.atari.2600-1.1.2.zip";
      sha256 = "0nydgswkmzshhvfia69m4zmjq7ighp96jziqhmn1ih5n2zjihp8l";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari 2600 Joystick";
      longDescription = ''
        The Atari CX40 joystick appeared on the Atari 2600 in 1977, and was considered such a great improvement over other controllers that it was the primary input device for most games.
      '';
      platform = platforms.all;
    };
  };
  game-controller-atari-5200 = mkKodiPlugin {
    plugin = "game-controller-atari-5200";
    namespace = "game.controller.atari.5200";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.atari.5200/game.controller.atari.5200-1.0.8.zip";
      sha256 = "1pnqbhks76vm4pgspsd683v4prxhy2k7jzwj8rwk7b3iydfp4hnd";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Atari 5200 Controller";
      longDescription = ''
        The Atari 5200 was released in 1982. The design of the joystick, which used a weak rubber boot instead of springs, proved to be ungainly and unreliable. It was rated the 10th worst video game controller by IGN.
      '';
      platform = platforms.all;
    };
  };
  game-controller-arcade-neogeo = mkKodiPlugin {
    plugin = "game-controller-arcade-neogeo";
    namespace = "game.controller.arcade.neogeo";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.arcade.neogeo/game.controller.arcade.neogeo-1.0.8.zip";
      sha256 = "1v1jlv5sxabrdg2z6zz4ia5v135nfl01qs6zfjdjr96qvz5s56j6";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Neo Geo Controller";
      longDescription = ''
        The controller for the Neo Geo AES (Advanced Entertainment System), a video game console released in the US in 1991. The Neo Geo AES was a niche system marketed toward high-end consumers. The console was expensive, as were the games themselves, which could go for hundreds of dollars.
      '';
      platform = platforms.all;
    };
  };
  game-controller-amstrad-joystick = mkKodiPlugin {
    plugin = "game-controller-amstrad-joystick";
    namespace = "game.controller.amstrad.joystick";
    version = "1.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.amstrad.joystick/game.controller.amstrad.joystick-1.0.3.zip";
      sha256 = "0y1n85lkqxk0xwbdlihzhwy96gq6ghqv8sysm632vz95k0dfw44r";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Amstrad Joystick";
      longDescription = ''
        The original Amstrad CPC models had only one joystick port. A Y-cable can be used to connect two joysticks.
      '';
      platform = platforms.all;
    };
  };
  game-controller-amstrad-keyboard = mkKodiPlugin {
    plugin = "game-controller-amstrad-keyboard";
    namespace = "game.controller.amstrad.keyboard";
    version = "1.0.3";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.amstrad.keyboard/game.controller.amstrad.keyboard-1.0.3.zip";
      sha256 = "161dkd76xrw2gzc81h6vf73b48rdv8y2sf2x5m4yi4l4i5wz2m7b";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: Amstrad Keyboard";
      longDescription = ''
        The Amstrad CPC (short for Colour Personal Computer) is a series of 8-bit home computers produced by Amstrad between 1984 and 1990.
      '';
      platform = platforms.all;
    };
  };
  game-controller-3do-gamegun = mkKodiPlugin {
    plugin = "game-controller-3do-gamegun";
    namespace = "game.controller.3do.gamegun";
    version = "1.0.8";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.3do.gamegun/game.controller.3do.gamegun-1.0.8.zip";
      sha256 = "1h5hqij8cxjmg0l42dqk1hccahzmkxzrmzsxxh7p2m3hqr6pzp77";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: 3DO Gamegun";
      longDescription = ''
        The Gamegun was released for the 3DO in 1994 by American Laser Games.
      '';
      platform = platforms.all;
    };
  };
  game-controller-3do = mkKodiPlugin {
    plugin = "game-controller-3do";
    namespace = "game.controller.3do";
    version = "1.0.9";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/game.controller.3do/game.controller.3do-1.0.9.zip";
      sha256 = "1arg0rwzpc6089mdyda5i46zwb2zg05bd5qn283jrhkdx4sv4vf8";
    };
    propagatedBuildInputs = [
    ];
    meta = with lib; {
      description = "Kodi addon: 3DO Controller";
      longDescription = ''
        The 3DO Interactive Multiplayer is a game console developed by the 3DO Company. Panasonic produced the first models in 1993, and further models were released by Sanyo and GoldStar (now LG) in 1994.
      '';
      platform = platforms.all;
    };
  };
  script-common-plugin-cache = python3Packages.toPythonModule (mkKodiPlugin {
    plugin = "script-common-plugin-cache";
    namespace = "script.common.plugin.cache";
    version = "2.6.1.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.common.plugin.cache/script.common.plugin.cache-2.6.1.1.zip";
      sha256 = "03qfi0mfrqlwdb9193vlikd2igh9fnfbhlan23c89qii683ww1nf";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Common plugin cache";
      platform = platforms.all;
    };
  });
  script-lazytv = mkKodiPlugin {
    plugin = "script-lazytv";
    namespace = "script.lazytv";
    version = "3.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/script.lazytv/script.lazytv-3.0.1.zip";
      sha256 = "1nmbq8202hjza42f4qk7lpkcgwgn031aykaz601rnk6db98shk5z";
    };
    propagatedBuildInputs = [
      xbmc-python # version 3.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: LazyTV";
      longDescription = ''
        You have a huge library of TV shows and you havent viewed half of it. So why does it feel like such a chore to sit down and watch something?
        LazyTV is here to free you from your battles with indecision, instead letting you lean back and soak up content. With one click you can be channel-surfing your own library, or have what you probably want to watch pop up in a single window.
        Afterall, you know you want to watch TV, so why do you also have to decide what specifically to watch?

        Unlike a smart playlist or skin widget, LazyTV doesnt just provide the first unwatched episode of a TV show. It provides the first unwatched episode AFTER the last watched one in your library. A small, but important, distinction.

        LazyTV offers two main functions:
        The first creates and launches a randomised playlist of the TV episodes. And not just any episodes, but the next episode it thinks you would want to watch. You also have the option to blend in your movies (both the watched and the unwatched) to complete the channel-surfing experience.
        The second main function populates a window with the next available episode for each of your TV Shows. One click and your viewing menu is there, immediately.

        Combine either of the main functions with a playlist of preselected shows to customise your experience even further.
        Some TV shows, like cartoons or skit shows, can be viewed out of episodic order. So LazyTV gives you the ability to identify these shows and treat them differently. Those shows will be played in a random order.

        LazyTV also offers two minor functions that extend beyond the addon itself:
        The first is an option to be notified if you are about to watch an episode that has an unwatched episode before it. This function excludes the TV shows identified as able to be watched out of order.
        The second option posts a notification when you finish watching a TV episode telling you that the next show is available and asks if you want to view it now.


        LazyTV contains a service that stores the next episodes' information and monitors your player to pre-empt database changes. This is my attempt to make the addon more responsive on my Raspberry Pi. The Pi still takes a while to "warm-up"; a full refresh of the episode data (which occurs at start-up and on a library update) takes about 30 seconds for my ~100 show library*. However, the show list window opens and the random player starts in less than 2 seconds.

        *The same update takes 2 seconds on my laptop with its i5 processor.
      '';
      homepage = "https://kodi.wiki/index.php?title=Add-on:LazyTV";
      platform = platforms.all;
    };
  };
  resource-language-te_in = mkKodiPlugin {
    plugin = "resource-language-te_in";
    namespace = "resource.language.te_in";
    version = "9.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.te_in/resource.language.te_in-9.0.2.zip";
      sha256 = "19qsvwyral1cv66wsr3yac2kn3s558zz3adbw94awrgi5xk3c9r3";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Telugu";
      longDescription = ''
        Telugu version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-ml_in = mkKodiPlugin {
    plugin = "resource-language-ml_in";
    namespace = "resource.language.ml_in";
    version = "9.0.1";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.ml_in/resource.language.ml_in-9.0.1.zip";
      sha256 = "07ypwi3a2mjbim7s0ypy1d7dg2hp4f1c7i92dv0lhcq15rz1mn1w";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Malayalam";
      longDescription = ''
        Malayalam version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
  resource-language-os_os = mkKodiPlugin {
    plugin = "resource-language-os_os";
    namespace = "resource.language.os_os";
    version = "1.0.2";
    src = fetchzip {
      url = "https://mirrors.kodi.tv/addons/matrix/resource.language.os_os/resource.language.os_os-1.0.2.zip";
      sha256 = "1awddkaimzkyrm0zpn0njjz40vrb3w5914qfsg4wrmzxscjnjini";
    };
    propagatedBuildInputs = [
      kodi-resource # version 1.0.0
    ];
    meta = with lib; {
      description = "Kodi addon: Ossetic";
      longDescription = ''
        Ossetic version of all texts used in Kodi.
      '';
      platform = platforms.all;
    };
  };
})
