{ lib, stdenv, fetchFromGitLab, fetchFromGitHub, fetchpatch
, file, libxslt, docbook_xml_dtd_412, docbook_xsl, xmlto
, w3m, gnugrep, gnused, coreutils, xset, perlPackages
, mimiSupport ? false, gawk
, glib
, withXdgOpenUsePortalPatch ? true }:

let
  # A much better xdg-open
  mimisrc = fetchFromGitHub {
    owner = "march-linux";
    repo = "mimi";
    rev = "8e0070f17bcd3612ee83cb84e663e7c7fabcca3d";
    sha256 = "15gw2nyrqmdsdin8gzxihpn77grhk9l97jp7s7pr7sl4n9ya2rpj";
  };

  perlPath = with perlPackages; makePerlPath [
    NetDBus XMLTwig XMLParser X11Protocol
  ];

in

stdenv.mkDerivation rec {
  pname = "xdg-utils";
<<<<<<< HEAD
  version = "unstable-2022-11-06";
=======
  version = "unstable-2020-10-21";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xdg";
    repo = "xdg-utils";
<<<<<<< HEAD
    rev = "8ae02631a9806da11b34cd6b274af02d28aee5da";
    sha256 = "sha256-WdnnAiPYbREny633FnBi5tD9hDuF8NCVVbUaAVIKTxM=";
=======
    rev = "d11b33ec7f24cfb1546f6b459611d440013bdc72";
    sha256 = "sha256-8PtXfI8hRneEpnUvIV3M+6ACjlkx0w/NEiJFdGbbHnQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = lib.optionals withXdgOpenUsePortalPatch [
    # Allow forcing the use of XDG portals using NIXOS_XDG_OPEN_USE_PORTAL environment variable.
    # Upstream PR: https://github.com/freedesktop/xdg-utils/pull/12
    ./allow-forcing-portal-use.patch
    # Allow opening files when using portal with xdg-open.
    # Upstream PR: https://gitlab.freedesktop.org/xdg/xdg-utils/-/merge_requests/65
    (fetchpatch {
      name = "support-openfile-with-portal.patch";
      url = "https://gitlab.freedesktop.org/xdg/xdg-utils/-/commit/5cd8c38f58d9db03240f4bc67267fe3853b66ec7.diff";
      hash = "sha256-snkhxwGF9hpqEh5NGG8xixTi/ydAk5apXRtgYrVgNY8=";
    })
  ];

  # just needed when built from git
  nativeBuildInputs = [ libxslt docbook_xml_dtd_412 docbook_xsl xmlto w3m ];

  postInstall = lib.optionalString mimiSupport ''
    cp ${mimisrc}/xdg-open $out/bin/xdg-open
  '' + ''
    sed  '2s#.#\
    sed()   { ${gnused}/bin/sed     "$@"; }\
    grep()  { ${gnugrep}/bin/grep   "$@"; }\
    egrep() { ${gnugrep}/bin/egrep  "$@"; }\
    file()  { ${file}/bin/file      "$@"; }\
    awk()   { ${gawk}/bin/awk       "$@"; }\
    xset()  { ${xset}/bin/xset      "$@"; }\
    perl()  { PERL5LIB=${perlPath} ${perlPackages.perl}/bin/perl "$@"; }\
    mimetype() { ${perlPackages.FileMimeInfo}/bin/mimetype "$@"; }\
    PATH=$PATH:'$out'/bin:${coreutils}/bin\
    &#' -i "$out"/bin/*

    substituteInPlace $out/bin/xdg-open \
      --replace "/usr/bin/printf" "${coreutils}/bin/printf" \
      --replace "gdbus" "${glib}/bin/gdbus"

    substituteInPlace $out/bin/xdg-mime \
      --replace "/usr/bin/file" "${file}/bin/file"

    substituteInPlace $out/bin/xdg-email \
      --replace "/bin/echo" "${coreutils}/bin/echo" \
      --replace "gdbus" "${glib}/bin/gdbus"

    sed 's|\bwhich\b|type -P|g' -i "$out"/bin/*
  '';

  meta = with lib; {
    homepage = "https://www.freedesktop.org/wiki/Software/xdg-utils/";
    description = "A set of command line tools that assist applications with a variety of desktop integration tasks";
    license = if mimiSupport then licenses.gpl2 else licenses.free;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
<<<<<<< HEAD
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
