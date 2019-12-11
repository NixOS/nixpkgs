{
  stdenv, fetchurl, lib,

  autoPatchelfHook,

  wrapQtAppsHook,

  libbsd,
  python27,
  gmpxx,
}:
let

in stdenv.mkDerivation rec {
  pname    = "hopper";
  version = "4.5.19";
  rev = "v${lib.versions.major version}";

  src = fetchurl {
    url = "https://d2ap6ypl1xbe4k.cloudfront.net/Hopper-${rev}-${version}-Linux.pkg.tar.xz";
    sha256 = "1c9wbjwz5xn0skz2a1wpxyx78hhrm8vcbpzagsg4wwnyblap59db";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    libbsd
    python27
    gmpxx
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share

    cp $sourceRoot/opt/hopper-${rev}/bin/Hopper $out/bin/hopper
    cp -r $sourceRoot/opt/hopper-${rev}/lib $out
    cp -r $sourceRoot/usr/share $out/share
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.hopperapp.com/index.html";
    description = "A macOS and Linux Disassembler";
    license = licenses.unfree;
    maintainers = [
      maintainers.luis
      maintainers.Enteee
    ];
    platforms = platforms.linux;
  };
}
