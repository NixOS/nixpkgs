{ lib, stdenv, fetchgit
, bison, flex, rasdaemon
}:

{
  edac-inject = rasdaemon.inject;

  mce-inject = stdenv.mkDerivation rec {
    pname = "mce-inject";
    version = "4cbe46321b4a81365ff3aafafe63967264dbfec5";

    src = fetchgit {
      url = "git://git.kernel.org/pub/scm/utils/cpu/mce/mce-inject.git";
      rev = version;
      sha256 = "0gjapg2hrlxp8ssrnhvc19i3r1xpcnql7xv0zjgbv09zyha08g6z";
    };

    nativeBuildInputs = [ bison flex ];

    makeFlags = [ "destdir=${placeholder "out"}" ];

    postInstall = ''
      mkdir $out/sbin
      mv $out/usr/sbin/mce-inject $out/sbin/mce-inject

      mkdir $out/test
      cp test/* $out/test/.
    '';

    meta = with lib; {
      description = "MCE error injection tool";
      license = licenses.gpl2Only;
      platforms = platforms.linux;
      maintainers = [ maintainers.evils ];
    };
  };

  aer-inject = stdenv.mkDerivation rec {
    pname = "aer-inject";
    version = "9bd5e2c7886fca72f139cd8402488a2235957d41";

    src = fetchgit {
      url = "git://git.kernel.org/pub/scm/linux/kernel/git/gong.chen/aer-inject.git";
      rev = version;
      sha256 = "0bh6mzpk2mr4xidkammmkfk21b4dbq793qjg25ryyxd1qv0c6cg4";
    };

    nativeBuildInputs = [ bison flex ];

    # how is this necessary?
    makeFlags = [ "DESTDIR=${placeholder "out"}" ];

    postInstall = ''
      mkdir $out/bin
      mv $out/usr/local/aer-inject $out/bin/aer-inject

      mkdir -p $out/examples
      cp examples/* $out/examples/.
    '';

    meta = with lib; {
      description = "PCIE AER error injection tool";
      license = licenses.gpl2Only;
      platforms = platforms.linux;
      maintainers = [ maintainers.evils ];
    };
  };
}
