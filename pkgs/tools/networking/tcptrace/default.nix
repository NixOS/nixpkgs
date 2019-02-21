{ stdenv, fetchurl, libpcap }:
let
  name        = "tcptrace";
  origVersion = "6.6.7";
  patch       = "5";

  version      = "${origVersion}-${patch}";
  srcTarball   = "${name}-${origVersion}.tar.gz";
  patchTarball = "${name}_${version}.debian.tar.xz";
  patchPath    = "${builtins.substring 0 1 name}/${name}/${patchTarball}";

  debianPatches = fetchurl {
    name   = "tcptrace-debian-patches.tar.xz";
    url    = "mirror://debian/pool/main/${patchPath}";
    sha256 = "0cx20064rw9v9jsh0fc91xy4sq8nzdn0wpp7fmg5d73fp544diyz";
  };

  origSrc = fetchurl {
    url    = "http://www.tcptrace.org/download/${srcTarball}";
    sha256 = "1g8hd6sqwf1f41am5m30kyy0i4wmdzy9ssj7g64s0g4ka500lf33";
  };
in stdenv.mkDerivation {
  inherit name version;

  srcs       = [ origSrc debianPatches ];
  sourceRoot = "${name}-${origVersion}";
  outputs    = [ "out" "man" ];

  setOutputFlags = false;

  patches  = [ ./fix-owners.patch ];
  prePatch = ''
    patches_deb=(../debian/patches/bug*)
    patches+=" ''${patches_deb[*]}"
  '';

  buildInputs = [ libpcap ];
  makeFlags   = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "man"}/share/man"
  ];

  meta = with stdenv.lib; {
    description = "a tool for analysis of TCP dump files";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ twey ];
    platforms   = platforms.unix;
  };
}
