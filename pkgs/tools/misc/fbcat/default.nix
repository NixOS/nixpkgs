{ stdenv, fetchFromGitHub } :

stdenv.mkDerivation rec {
  pname = "fbcat";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "jwilk";
    repo = pname;
    rev = version;
    sha256 = "08y79br4a4cgkjnslw0hw57441ybsapaw7wjdbak19mv9lnl5ll9";
  };

  # hardcoded because makefile target "install" depends on libxslt dependencies from network
  # that are just too hard to monkeypatch here
  # so this is the simple fix.
  installPhase = ''
    mkdir -p $out
    install -d $out/bin
    install -m755 fbcat $out/bin/
    install -m755 fbgrab $out/bin/
    install -d $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    homepage = "http://jwilk.net/software/fbcat";
    description = "Framebuffer screenshot tool";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}

