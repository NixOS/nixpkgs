{ stdenv, fetchurl, pcre2 }:


stdenv.mkDerivation rec {
  name = "hardlink-${version}";
  version = "1.3-4";

  src = fetchurl {
    url = "https://src.fedoraproject.org/cgit/rpms/hardlink.git/snapshot/hardlink-aa6325ac4e8100b8ac7d38c7f0bc2708e69bd855.tar.xz";
    sha256 = "0g4hyrnd9hpykbf06qvvp3s4yyk7flbd95gilkf7r3w9vqiagvs2";
  };

  buildInputs = [ pcre2 ];
  NIX_CFLAGS_LINK = "-lpcre2-8";

  buildPhase = ''
    $CC -O2 hardlink.c -o hardlink $NIX_CFLAGS_LINK
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp -f hardlink $out/bin/hardlink
    cp -f hardlink.1 $out/share/man/man1/hardlink.1
  '';

  meta = with stdenv.lib; {
    description = "Consolidate duplicate files via hardlinks";
    homepage = https://pagure.io/hardlink;
    repositories.git = https://src.fedoraproject.org/cgit/rpms/hardlink.git;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
