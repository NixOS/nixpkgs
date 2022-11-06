{ lib
, stdenv
, autoreconfHook
, buildPackages
, coreutils
, fetchFromGitHub
, jansson
, libiconv
, perl
, pkg-config
, python3
, libseccomp
, libyaml
, pcre2
, libxml2
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "universal-ctags";
  version = "5.9.20221106.0";

  src = fetchFromGitHub {
    owner = "universal-ctags";
    repo = "ctags";
    rev = "p${finalAttrs.version}";
    hash = "sha256-6piWdofvlX+ysXmRPnQc7PlZuHSyVqdVxOztY2+Pcss=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    (python3.withPackages (p: [ p.docutils ]))
  ];

  buildInputs = [
    libseccomp
    libyaml
    pcre2
    libxml2
    jansson
  ]
  ++ lib.optional stdenv.isDarwin libiconv;

  configureFlags = [ "--enable-tmpdir=/tmp" ];

  patches = [
    ./000-nixos-specific.patch
  ];

  postPatch = ''
    substituteInPlace Tmain/utils.sh \
      --replace /bin/echo ${coreutils}/bin/echo

    patchShebangs misc/*
  '';

  doCheck = true;

  checkFlags = [
    "man-test" "tlib" "tmain" "tutil" "units"
  ];

  meta = with lib; {
    homepage = "https://docs.ctags.io/en/latest/";
    description = "A maintained ctags implementation";
    longDescription = ''
      Universal Ctags (abbreviated as u-ctags) is a maintained implementation of
      ctags. ctags generates an index (or tag) file of language objects found in
      source files for programming languages. This index makes it easy for text
      editors and other tools to locate the indexed items.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
    mainProgram = "ctags";
    priority = 1; # over the emacs implementation
  };
})
