{ newScope, crossLibcStdenv }: let

  callPackage = newScope self;

  self = {
    cygwinSetup = callPackage ./cygwin-setup { };

    jom = callPackage ./jom { };

    w32api = callPackage ./w32api { };

    mingwrt = callPackage ./mingwrt { };
    mingw_runtime = self.mingwrt;

    mingw_w64 = callPackage ./mingw-w64 {
      stdenv = crossLibcStdenv;
    };

    mingw_w64_headers = callPackage ./mingw-w64/headers.nix { };

    mingw_w64_pthreads = callPackage ./mingw-w64/pthreads.nix { };

    pthreads = callPackage ./pthread-w32 { };

    wxMSW = callPackage ./wxMSW-2.8 { };

    libgnurx = callPackage ./libgnurx { };
  };
in self
