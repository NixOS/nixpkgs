/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

   e.g.

   $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/

{ nixpkgs ? { outPath = (import ./../.. {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
, # The platforms for which we build Nixpkgs.
  supportedSystems ? [ "x86_64-linux" "i686-linux" "x86_64-darwin" ]
, scrubJobs ? true
}:

with import ./release-lib.nix { inherit supportedSystems scrubJobs; };

let

  lib = pkgs.lib;

  jobs =
    { tarball = import ./make-tarball.nix { inherit pkgs nixpkgs officialRelease; };

      metrics = import ./metrics.nix { inherit pkgs nixpkgs; };

      manual = import ../../doc;
      lib-tests = import ../../lib/tests/release.nix { inherit nixpkgs; };

      unstable = pkgs.releaseTools.aggregate
        { name = "nixpkgs-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs unstable channel";
          constituents =
            [ jobs.tarball
              jobs.manual
              jobs.lib-tests
              jobs.stdenv.x86_64-linux
              jobs.stdenv.i686-linux
              jobs.stdenv.x86_64-darwin
              jobs.linux.x86_64-linux
              jobs.linux.i686-linux
              jobs.python.x86_64-linux
              jobs.python.i686-linux
              jobs.python.x86_64-darwin
              jobs.python3.x86_64-linux
              jobs.python3.i686-linux
              jobs.python3.x86_64-darwin
              # Ensure that X11/GTK+ are in order.
              jobs.thunderbird.x86_64-linux
              jobs.thunderbird.i686-linux
              # Ensure that basic stuff works on darwin
              jobs.git.x86_64-darwin
              jobs.mysql.x86_64-darwin
              jobs.vim.x86_64-darwin
            ] ++ lib.collect lib.isDerivation jobs.stdenvBootstrapTools;
        };

      stdenvBootstrapTools.i686-linux =
        { inherit (import ../stdenv/linux/make-bootstrap-tools.nix { system = "i686-linux"; }) dist test; };

      stdenvBootstrapTools.x86_64-linux =
        { inherit (import ../stdenv/linux/make-bootstrap-tools.nix { system = "x86_64-linux"; }) dist test; };

      stdenvBootstrapTools.x86_64-darwin =
        let
          bootstrap = import ../stdenv/darwin/make-bootstrap-tools.nix { system = "x86_64-darwin"; };
        in {
          # Lightweight distribution and test
          inherit (bootstrap) dist test;
          # Test a full stdenv bootstrap from the bootstrap tools definition
          inherit (bootstrap.test-pkgs) stdenv;
        };

    } // (mapTestOn ((packagePlatforms pkgs) // rec {

      # TODO: most (but possibly not all) of the jobs specified here are unnecessary now that we have release-lib.nix
      # traversing all packages and looking at their meta.platform attributes. Someone who's better at this than I am
      # should go through these and kill the ones that are safe to kill.
      #
      # <niksnut> note that all that " = linux" stuff in release.nix is legacy, from before we had meta.platforms
      # <copumpkin> niksnut: so should I just kill all the obsolete jobs in release.nix?
      # <niksnut> I don't know if they're all covered
      abcde = linux;
      aspell = all;
      atlas = linux;
      bazaar = linux; # first let sqlite3 work on darwin
      binutils = linux;
      bind = linux;
      bvi = all;
      cdrkit = linux;
      classpath = linux;
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
      flex = all;
      fontforge = linux;
      gajim = linux;
      gawk = all;
      gcc = linux;
      gcc44 = linux;
      gcj = linux;
      ghostscript = linux;
      ghostscriptX = linux;
      glibc = linux;
      glibcLocales = linux;
      glxinfo = linux;
      gnum4 = all;
      gnupg = linux;
      gnuplot = allBut cygwin;
      gnutls = linux;
      gogoclient = linux;
      gphoto2 = linux;
      gpscorrelate = linux;
      gqview = gtkSupported;
      gsl = linux;
      guile = linux;  # tests fail on Cygwin
      html-tidy = all;
      icewm = linux;
      inkscape = linux;
      irssi = linux;
      jnettop = linux;
      keen4 = ["i686-linux"];
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
      man-pages = linux;
      maxima = linux;
      mc = linux;
      mcabber = linux;
      mcron = linux;
      mdadm = linux;
      mercurial = unix;
      mercurialFull = linux;
      mesa = mesaPlatforms;
      mk = linux;
      mktemp = all;
      mod_python = linux;
      mupen64plus = linux;
      mutt = linux;
      nano = allBut cygwin;
      ncat = linux;
      netcat = all;
      nss_ldap = linux;
      nssmdns = linux;
      ocaml = linux;
      pciutils = linux;
      pdf2xml = all;
      php = linux;
      pltScheme = linux;
      pmccabe = linux;
      ppl = all;
      procps = linux;
      pygtk = linux;
      python = allBut cygwin;
      pythonFull = linux;
      sbcl = linux;
      qt3 = linux;
      quake3demo = linux;
      reiserfsprogs = linux;
      rubber = allBut cygwin;
      rxvt_unicode = linux;
      scrot = linux;
      sdparm = linux;
      seccure = linux;
      sgtpuzzles = linux;
      sloccount = allBut cygwin;
      spidermonkey = linux;
      squid = linux;
      ssmtp = linux;
      stdenv = all;
      stlport = linux;
      superTuxKart = linux;
      swig = linux;
      tahoelafs = linux;
      tangogps = linux;
      tcl = linux;
      teeworlds = linux;
      tightvnc = linux;
      time = linux;
      tinycc = linux;
      uae = linux;
      viking = linux;
      vice = linux;
      vimHugeX = linux;
      vncrec = linux;
      vorbis-tools = linux;
      vsftpd = linux;
      w3m = all;
      weechat = linux;
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

      #emacs24PackagesNg = packagePlatforms pkgs.emacs24PackagesNg;

      gnome = {
        gnome_panel = linux;
        metacity = linux;
        gnome_vfs = linux;
      };

      haskell.compiler = packagePlatforms pkgs.haskell.compiler;
      haskellPackages = packagePlatforms pkgs.haskellPackages;

      #rPackages = packagePlatforms pkgs.rPackages;

      strategoPackages = {
        sdf = linux;
        strategoxt = linux;
        javafront = linux;
        strategoShell = linux ++ darwin;
        dryad = linux;
      };

      ocamlPackages = { };

      perlPackages = { };

      pythonPackages = { };
      python2Packages = { };
      python27Packages = { };
      python3Packages = { };
      python35Packages = { };

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
