/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

   e.g.

   $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/

{ nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" "i686-linux" /* "x86_64-darwin" */ ]
}:

with import ./release-lib.nix { inherit supportedSystems; };

let

  jobs =
    { tarball = import ./make-tarball.nix { inherit nixpkgs officialRelease; };

      manual = import ../../doc;

      unstable = pkgs.releaseTools.aggregate
        { name = "nixpkgs-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs unstable channel";
          constituents =
            [ jobs.tarball
              jobs.manual
              jobs.stdenv.x86_64-linux
              jobs.stdenv.i686-linux
              #jobs.stdenv.x86_64-darwin
              jobs.linux.x86_64-linux
              jobs.linux.i686-linux
              # Ensure that X11/GTK+ are in order.
              jobs.thunderbird.x86_64-linux
              jobs.thunderbird.i686-linux
              /* not ready yet
              jobs.glib-tested.x86_64-linux # standard glib doesn't do checks
              jobs.glib-tested.i686-linux
              */
            ];
        };

    } // (mapTestOn ((packagesWithMetaPlatform pkgs) // rec {

      abcde = linux;
      apacheHttpd = linux;
      aspell = all;
      at = linux;
      atlas = linux;
      autoconf = all;
      automake = all;
      bash = all;
      bashInteractive = all;
      bazaar = linux; # first let sqlite3 work on darwin
      binutils = linux;
      bind = linux;
      bvi = all;
      castle_combat = linux;
      cdrkit = linux;
      cksfv = all;
      classpath = linux;
      coreutils = all;
      cron = linux;
      cvs = linux;
      ddrescue = linux;
      dhcp = linux;
      dico = linux;
      dietlibc = linux;
      diffutils = all;
      disnix = all;
      disnixos = linux;
      DisnixWebService = linux;
      docbook5 = all;
      docbook5_xsl = all;
      docbook_xml_dtd_42 = all;
      docbook_xml_dtd_43 = all;
      docbook_xsl = all;
      dosbox = linux;
      dovecot = linux;
      doxygen = linux;
      drgeo = linux;
      ejabberd = linux;
      elinks = linux;
      eprover = linux;
      expect = linux;
      exult = linux;
      findutils = all;
      flex = all;
      fontforge = linux;
      gajim = linux;
      gawk = all;
      gcc = linux;
      gcc34 = linux;
      gcc44 = linux;
      gcj = linux;
      ghostscript = linux;
      ghostscriptX = linux;
      git = linux;
      gitFull = linux;
      glibc = linux;
      glibcLocales = linux;
      glxinfo = linux;
      gnum4 = all;
      gnupg = linux;
      gnuplot = allBut cygwin;
      gnutls = linux;
      gogoclient = linux;
      gphoto2 = linux;
      gpm = linux;
      gpscorrelate = linux;
      gqview = gtkSupported;
      graphviz = all;
      grub = linux;
      gsl = linux;
      guile = linux;  # tests fail on Cygwin
      gzip = all;
      hddtemp = linux;
      host = linux;
      htmlTidy = all;
      iana_etc = linux;
      icewm = linux;
      ifplugd = linux;
      inkscape = linux;
      irssi = linux;
      jfsutils = linux;
      jnettop = linux;
      jwhois = linux;
      kbd = linux;
      keen4 = ["i686-linux"];
    #  klibc = linux;
      less = all;
      lftp = all;
      libarchive = linux;
      libtool = all;
      libtool_2 = all;
      lout = linux;
      lsof = linux;
      ltrace = linux;
      lynx = linux;
      lzma = linux;
      man = linux;
      manpages = linux;
      maxima = linux;
      mc = linux;
      mcabber = linux;
      mcron = linux;
      mdadm = linux;
      mercurial = unix;
      mercurialFull = linux;
      mesa = mesaPlatforms;
      mingetty = linux;
      mk = linux;
      mktemp = all;
      mod_python = linux;
      module_init_tools = linux;
      mupen64plus = linux;
      mutt = linux;
      mysql = linux;
      mysql51 = linux;
      mysql55 = linux;
      nano = allBut cygwin;
      ncat = linux;
      netcat = all;
      nss_ldap = linux;
      nssmdns = linux;
      ocaml = linux;
      pam_console = linux;
      pam_login = linux;
      pan = gtkSupported;
      par2cmdline = all;
      pciutils = linux;
      pdf2xml = all;
      perl = all;
      php = linux;
      pinentry = linux;
      pltScheme = linux;
      pmccabe = linux;
      portmap = linux;
      postgresql = all;
      ppl = all;
      procps = linux;
      pthreadmanpages = linux;
      pygtk = linux;
      python = allBut cygwin;
      pythonFull = linux;
      sbcl = linux;
      qt3 = linux;
      quake3demo = linux;
      reiserfsprogs = linux;
      rlwrap = all;
      rogue = all;
      rpm = linux;
      rsync = linux;
      rubber = allBut cygwin;
      rxvt_unicode = linux;
      screen = linux ++ darwin;
      scrot = linux;
      sdparm = linux;
      seccure = linux;
      sgtpuzzles = linux;
      sloccount = allBut cygwin;
      spidermonkey = linux;
      squid = linux;
      ssmtp = linux;
      stdenv = prio 175 all;
      stlport = linux;
      su = linux;
      sudo = linux;
      superTuxKart = linux;
      swig = linux;
      sysklogd = linux;
      syslinux = ["i686-linux"];
      sysvinit = linux;
      sysvtools = linux;
      tahoelafs = linux;
      tangogps = linux;
      tcl = linux;
      tcpdump = linux;
      teeworlds = linux;
      tetex = linux;
      texLive = linux;
      texLiveBeamer = linux;
      texLiveExtra = linux;
      tightvnc = linux;
      time = linux;
      tinycc = linux;
      uae = linux;
      unrar = linux;
      upstart = linux;
      usbutils = linux;
      utillinux = linux;
      utillinuxCurses = linux;
      viking = linux;
      vice = linux;
      vim = linux;
      vimHugeX = linux;
      vncrec = linux;
      vorbisTools = linux;
      vsftpd = linux;
      w3m = all;
      weechat = linux;
      which = all;
      wicd = linux;
      wine = ["i686-linux"];
      wirelesstools = linux;
      wxGTK = linux;
      x11_ssh_askpass = linux;
      xchm = linux;
      xfig = x11Supported;
      xfsprogs = linux;
      xineUI = linux;
      xkeyboard_config = linux;
      xlockmore = linux;
      xpdf = linux;
      xscreensaver = linux;
      xsel = linux;
      xterm = linux;
      zdelta = linux;
      zsh = linux;
      zsnes = ["i686-linux"];

      gnome = {
        gnome_panel = linux;
        metacity = linux;
        gnome_vfs = linux;
      };

      haskellPackages_ghc6104 = {
        ghc = ghcSupported;
      };

      haskellPackages_ghc6123 = {
        ghc = ghcSupported;
      };

      haskellPackages_ghc704 = {
        ghc = ghcSupported;
      };

      haskellPackages_ghc722 = {
        ghc = ghcSupported;
      };

      haskellPackages_ghc742 = {
        ghc = ghcSupported;
      };

      haskellPackages_ghc763 = {
        ghc = ghcSupported;
      };

      strategoPackages = {
        sdf = linux;
        strategoxt = linux;
        javafront = linux;
        strategoShell = linux ++ darwin;
        dryad = linux;
      };

      pythonPackages = {
        zfec = linux;
      };

      xorg = {
        fontadobe100dpi = linux ++ darwin;
        fontadobe75dpi = linux ++ darwin;
        fontbh100dpi = linux ++ darwin;
        fontbhlucidatypewriter100dpi = linux ++ darwin;
        fontbhlucidatypewriter75dpi = linux ++ darwin;
        fontbhttf = linux ++ darwin;
        fontcursormisc = linux ++ darwin;
        fontmiscmisc = linux ++ darwin;
        iceauth = linux ++ darwin;
        libX11 = linux ++ darwin;
        lndir = all ++ darwin;
        setxkbmap = linux ++ darwin;
        xauth = linux ++ darwin;
        xbitmaps = linux ++ darwin;
        xev = linux ++ darwin;
        xf86inputevdev = linux;
        xf86inputkeyboard = linux;
        xf86inputmouse = linux;
        xf86inputsynaptics = linux;
        xf86videoati = linux;
        xf86videocirrus = linux;
        xf86videointel = linux;
        xf86videonv = linux;
        xf86videovesa = linux;
        xf86videovmware = linux;
        xf86videomodesetting = linux;
        xfs = linux ++ darwin;
        xinput = linux ++ darwin;
        xkbcomp = linux ++ darwin;
        xlsclients = linux ++ darwin;
        xmessage = linux ++ darwin;
        xorgserver = linux ++ darwin;
        xprop = linux ++ darwin;
        xrandr = linux ++ darwin;
        xrdb = linux ++ darwin;
        xset = linux ++ darwin;
        xsetroot = linux ++ darwin;
        xwininfo = linux ++ darwin;
      };

      xfce = {
        gtk_xfce_engine = linux;
        mousepad = linux;
        ristretto = linux;
        terminal = linux;
        thunar = linux;
        xfce4_power_manager = linux;
        xfce4icontheme = linux;
        xfce4mixer = linux;
        xfce4panel = linux;
        xfce4session = linux;
        xfce4settings = linux;
        xfdesktop = linux;
        xfwm4 = linux;
      };

      linuxPackages_testing = { };
      linuxPackages_grsec_stable_desktop = { };
      linuxPackages_grsec_stable_server = { };
      linuxPackages_grsec_stable_server_xen = { };
      linuxPackages_grsec_testing_desktop = { };
      linuxPackages_grsec_testing_server = { };
      linuxPackages_grsec_testing_server_xen = { };

    } ));

in jobs
