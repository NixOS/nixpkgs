{ rev, sha256, version }:

{ lib, stdenv, fetchFromGitLab, autoreconfHook, pkg-config, cairo, expat, flex
, fontconfig, gd, gettext, gts, libdevil, libjpeg, libpng, libtool, pango
, bison, fetchpatch, xorg, ApplicationServices, python3 }:

let
  inherit (lib) optional optionals optionalString;
  raw_patch =
    # https://gitlab.com/graphviz/graphviz/issues/1367 CVE-2018-10196
    fetchpatch {
      name = "CVE-2018-10196.patch";
      url = "https://gitlab.com/graphviz/graphviz/uploads/30f8f0b00e357c112ac35fb20241604a/p.diff";
      sha256 = "074qx6ch9blrnlilmz7p96fkiz2va84x2fbqdza5k4808rngirc7";
      excludes = ["tests/*"]; # we don't run them and they don't apply
    };
  # the patch needs a small adaption for older versions
  patchToUse = if lib.versionAtLeast version "2.37" then raw_patch else
  stdenv.mkDerivation {
    inherit (raw_patch) name;
    buildCommand = "sed s/dot_root/agroot/g ${raw_patch} > $out";
  };
  # 2.42 has the patch included
  patches = optional (lib.versionOlder version "2.42") patchToUse
  ++ optionals (lib.versionOlder version "2.46.0") [
    (fetchpatch {
      name = "CVE-2020-18032.patch";
      url = "https://gitlab.com/graphviz/graphviz/-/commit/784411ca3655c80da0f6025ab20634b2a6ff696b.patch";
      sha256 = "1nkw9ism8lkfvxsp5fh95i2l5s5cbjsidbb3g1kjfv10rxkyb41m";
    })
  ];
in

stdenv.mkDerivation {
  pname = "graphviz";
  inherit version;

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    inherit sha256 rev;
  };

  nativeBuildInputs = [ autoreconfHook pkg-config python3 ];

  buildInputs = [
    libpng libjpeg expat bison libtool fontconfig gd gts libdevil flex pango
    gettext
  ] ++ optionals (xorg != null) (with xorg; [ libXrender libXaw libXpm ])
    ++ optionals (stdenv.isDarwin) [ ApplicationServices ];

  hardeningDisable = [ "fortify" ];

  CPPFLAGS = lib.optionalString (xorg != null && stdenv.isDarwin)
    "-I${cairo.dev}/include/cairo";

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
  ] ++ lib.optional (xorg == null) "--without-x";

  inherit patches;

  postPatch = ''
    for f in $(find . -name Makefile.in); do
      substituteInPlace $f --replace "-lstdc++" "-lc++"
    done
  '';

  # ''
  #   substituteInPlace rtest/rtest.sh \
  #     --replace "/bin/ksh" "${mksh}/bin/mksh"
  # '';

  doCheck = false; # fails with "Graphviz test suite requires ksh93" which is not in nixpkgs

  preAutoreconf = "./autogen.sh";

  postFixup = optionalString (xorg != null) ''
    substituteInPlace $out/bin/dotty --replace '`which lefty`' $out/bin/lefty
    substituteInPlace $out/bin/vimdot \
      --replace /usr/bin/vi '$(command -v vi)' \
      --replace /usr/bin/vim '$(command -v vim)' \
      --replace /usr/bin/vimdot $out/bin/vimdot \
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://graphviz.org";
    description = "Graph visualization tools";
    license = licenses.epl10;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor raskin ];
  };
}
