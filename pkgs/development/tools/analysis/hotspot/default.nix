{ stdenv,
  cmake,
  elfutils,
  extra-cmake-modules,
  fetchFromGitHub,
  kconfigwidgets,
  ki18n,
  kitemmodels,
  kitemviews,
  libelf,
  qtbase,
  threadweaver,
}:

stdenv.mkDerivation rec {
  name = "hotspot-${version}";
  version = "1.0.0"; # don't forget to bump `rev` below when you change this

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "hotspot";
    # TODO: For some reason, `fetchSubmodules` doesn't work when using `rev = "v${version}";`,
    #       so using an explicit commit instead. See #15559
    rev = "352687bf620529e9887616651f123f922cb421a4";
    sha256 = "09ly15yafpk31p3w7h2xixf1xdmx803w9fyb2aq7mhmc7pcxqjsx";
    fetchSubmodules = true;
  };

  buildInputs = [
    cmake
    elfutils
    extra-cmake-modules
    kconfigwidgets
    ki18n
    kitemmodels
    kitemviews
    libelf
    qtbase
    threadweaver
  ];

  # hotspot checks for the presence of third party libraries'
  # git directory to give a nice warning when you forgot to clone
  # submodules; but Nix clones them and removes .git (for reproducibility).
  # So we need to fake their existence here.
  postPatch = ''
    mkdir -p 3rdparty/perfparser/.git
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A GUI for Linux perf";
    longDescription = ''
      hotspot is a GUI replacement for `perf report`.
      It takes a perf.data file, parses and evaluates its contents and
      then displays the result in a graphical way.
    '';
    homepage = https://github.com/KDAB/hotspot;
    license = with stdenv.lib.licenses; [ gpl2 gpl3 ];
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ nh2 ];
  };
}
