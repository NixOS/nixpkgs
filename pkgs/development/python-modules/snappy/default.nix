{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  snappy-15-knots,
  cypari,
  fxrays,
  ipython,
  low-index,
  packaging,
  pickleshare,
  plink,
  pypng,
  pyx,
  spherogram,
  tkinter-gl,
  libGL,
  libX11,
  include15CrossingKnots ? true,
}:

buildPythonPackage rec {
  pname = "snappy";
  version = "3.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "3-manifolds";
    repo = "SnapPy";
    tag = "${version}_as_released";
    hash = "sha256:0njfy1q0s5wx5hhllgibqvdgjp1asfhx72dz61rbxc234nxz20r3";
  };

  build-system = [
    setuptools
    cython
  ];

  buildInputs = [
    libGL
    libX11
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "/usr/include/GL" "${libGL.dev}/include/GL"
  '';

  preBuild = ''
    export SNAPPY_ALWAYS_BUILD_CYOPENGL="True"
    export NIX_CFLAGS_COMPILE="-I${libGL.dev}/include -I${libX11.dev}/include"
  '';

  postInstall = ''
    cp -r $PWD/freedesktop/share $out/
    substituteInPlace $out/share/applications/snappy.desktop \
      --replace "Exec=/usr/bin/env python3 -m snappy.app" "Exec=$out/bin/SnapPy"
  '';

  dependencies = [
    cypari
    fxrays
    ipython
    low-index
    packaging
    pickleshare
    plink
    pypng
    pyx
    spherogram
    tkinter-gl
  ] ++ lib.optionals include15CrossingKnots [ snappy-15-knots ];

  pythonImportsCheck = [ "snappy" ];

  meta = with lib; {
    description = "A program for studying the topology and geometry of 3-manifolds, with a focus on hyperbolic structures.";
    homepage = "https://snappy.computop.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ noiioiu ];
    platforms = with platforms; linux;
  };
}
