{ stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  name = "tcpdump-${version}";
  version = "4.9.2";

  # leaked embargoed security update
  src = fetchurl {
    url = "https://src.fedoraproject.org/lookaside/pkgs/tcpdump/tcpdump-4.9.2.tar.gz/sha512/e1bc19a5867d6e3628f3941bdf3ec831bf13784f1233ca1bccc46aac1702f47ee9357d7ff0ca62cddf211b3c8884488c21144cabddd92c861e32398cd8f7c44b/tcpdump-4.9.2.tar.gz";
    sha256 = "0ygy0layzqaj838r5xd613iraz09wlfgpyh7pc6cwclql8v3b2vr";
  };
  # src = fetchFromGitHub rec {
  #   owner = "the-tcpdump-group";
  #   repo = "tcpdump";
  #   rev = "${repo}-${version}";
  #   sha256 = "1vzrvn1q7x28h18yskqc390y357pzpg5xd3pzzj4xz3llnvsr64p";
  # };

  postPatch = ''
    patchShebangs tests
  '';

  checkInputs = [ perl ];

  buildInputs = [ libpcap ];

  configureFlags = stdenv.lib.optional
    (stdenv.hostPlatform != stdenv.buildPlatform)
    "ac_cv_linux_vers=2";

  meta = {
    description = "Network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ jgeerds ];
    platforms = stdenv.lib.platforms.linux;
  };
}
