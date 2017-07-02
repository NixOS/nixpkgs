{ stdenv, xlibs, fetchgit }:

stdenv.mkDerivation { name = "x11idle";
      src = fetchgit{ url = "git://orgmode.org/org-mode.git";
                      rev = "fbd865941f3105f689f78bf053bb3b353b9b8a23";
                      sha256 = "0ma3m48f4s38xln0gl1ww9i5x28ij0ipxc94kx5h2931zy7lqzvz"; };
      installPhase = "mkdir -p $out/bin; gcc -lXss -lX11 $src/contrib/scripts/x11idle.c -o $out/bin/x11idle";
      unpackPhase = ":";
      buildInputs = [ xlibs.libXScrnSaver xlibs.libX11 ];
      meta = {
           description = "Gather the current idle time from X11.";
           homepage = "http://orgmode.org/";
           license = stdenv.lib.licenses.free;
           platforms = stdenv.lib.platforms.linux;
           maintainers = [ stdenv.lib.maintainers.swflint ];
      }; }
