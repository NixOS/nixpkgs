{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libassuan
, libgpg-error
, libiconv
, texinfo
, Cocoa
}:

stdenv.mkDerivation rec {
  pname = "pinentry-mac";
  version = "1.1.1.1";

  src = fetchFromGitHub {
    owner = "GPGTools";
    repo = "pinentry";
    rev = "v${version}";
    sha256 = "sha256-QnDuqFrI/U7aZ5WcOCp5vLE+w59LVvDGOFNQy9fSy70=";
  };

  postPatch = ''
    substituteInPlace macosx/Makefile.am --replace ibtool /usr/bin/ibtool
  '';

  nativeBuildInputs = [ autoreconfHook texinfo ];
  buildInputs = [ libassuan libgpg-error libiconv Cocoa ];

  configureFlags = [ "--enable-maintainer-mode" "--disable-ncurses" ];

  # This is required to let ibtool run.
  sandboxProfile = ''
    (allow process-exec
      (literal "/usr/bin/ibtool")
      (regex "/Xcode.app/Contents/Developer/usr/bin/ibtool")
      (regex "/Xcode.app/Contents/Developer/usr/bin/xcodebuild")
      (literal "/usr/libexec/PlistBuddy"))
    (allow file-read*)
    (deny file-read* (subpath "/usr/local") (with no-log))
    (allow file-write* (subpath "/private/var/folders"))
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv macosx/pinentry-mac.app $out/Applications
  '';

  passthru = {
    binaryPath = "Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
  };

  meta = {
    description = "Pinentry for GPG on Mac";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/GPGTools/pinentry-mac";
    platforms = lib.platforms.darwin;
  };
}
