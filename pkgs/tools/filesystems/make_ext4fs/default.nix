{ stdenv, fetchgit, zlib }:

stdenv.mkDerivation {
  pname = "make_ext4fs";
  version = "unstable-2017-05-21";

  src = fetchgit {
    url = "git://git.openwrt.org/project/make_ext4fs.git";
    rev = "eebda1d55d9701ace2700d7ae461697fadf52d1f";
    sha256 = "03lqd5qy3nli9mmnlbgxwsplwz8v10cyjyzl1fxcfz8jvzr00c61";
  };

  patches = [
    ./0001-uuid-add-facilities-to-parse-and-print-UUIDs.patch
    ./0002-make_ext4fs-allow-setting-a-specific-UUID.patch
  ];

  buildInputs = [
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp make_ext4fs $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://git.openwrt.org/?p=project/make_ext4fs.git;
    description = "Standalone fork of Android make_ext4fs utility";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.samueldr ];
  };
}
