{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, writeText
, dejavu_fonts
, fontconfig
, numpy
, pillow
, pybind11
, pytestCheckHook
, skia_m87
}:

let
  skia = skia_m87.overrideAttrs (oldAttrs: {
    gnFlags = oldAttrs.gnFlags ++ [
      "extra_cflags_cc=[\"-frtti\"]"
      "extra_ldflags=[\"-lrt\"]"
    ];
    ninjaFlags = oldAttrs.ninjaFlags ++ [
      "experimental_svg_model"
    ];
    postInstall = ''
      cp -r --parents -t $out/ \
        experimental/svg/model/SkSVGAttribute.h \
        experimental/svg/model/SkSVGDOM.h \
        experimental/svg/model/SkSVGIDMapper.h \
        experimental/svg/model/SkSVGNode.h \
        experimental/svg/model/SkSVGTypes.h \
        src/core/SkTLazy.h \
        out/Release/obj/experimental/svg/model/*.o
    '';
  });
in
buildPythonPackage rec {
  pname = "skia-python";
  version = "87.5";

  # PyPI only has bdists, no source. Fetch from GitHub instead.
  src = fetchFromGitHub {
    owner = "kyamagu";
    repo = "skia-python";
    rev = "v${version}";
    hash = "sha256-PGlhcte5+q+dEAW3FMdLM7UeI/OwUGIDgiDjkxONRQI=";
  };

  propagatedBuildInputs = [
    numpy
    skia
  ];
  nativeBuildInputs = [
    pybind11
  ];
  nativeCheckInputs = [
    pillow
    pytestCheckHook
  ];

  patches = [
    # Upstream declares pybind11 as a runtime requirement, but it's actually
    # only used at build time. Remove it from setup.py install_requires so that
    # we don't have to propagate the dependency needlessly.
    ./0001-pybind11-is-not-required-at-runtime.patch
  ];

  postPatch = ''
    # These are libskia.a's dynamic dependencies, but it has no way of telling
    # us which libs we need to link so we have to just hardcode the list here.
    substituteInPlace setup.py \
      --replace "libraries=LIBRARIES" \
                "libraries=LIBRARIES + ['icuuc', 'jpeg', 'png', 'webp', 'webpdemux', 'webpmux']"
  '';

  SKIA_PATH = skia;

  # The tests try to load a font named "monospace". This is just a minimal
  # fonts.conf to make that possible.
  fontsConfForTests = writeText "skia-python-tests-fonts.conf" ''
    <?xml version='1.0'?>
    <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
    <fontconfig>
      <include>${fontconfig.out}/etc/fonts/conf.d</include>
      <dir>${dejavu_fonts}</dir>
    </fontconfig>
  '';

  preCheck = ''
    export FONTCONFIG_FILE=${fontsConfForTests}

    # Some tests want to grab test data from the resources subdirectory of the
    # skia submodule, which we don't have. Symlink it into place.
    ln -s ${skia.src}/resources skia/resources
  '';

  passthru.skia = skia;
  passthru.tests.notebooks = callPackage (
    { stdenvNoCC, execnb, skia-python }:
    stdenvNoCC.mkDerivation {
      name = "${pname}-test-notebooks";
      meta.timeout = 10;
      buildInputs = [ skia-python ];
      FONTCONFIG_FILE = fontsConfForTests;
      buildCommand = ''
        mkdir -p $out
        notebooks=(
          # Canvas-Creation.ipynb has a cell which tries to use glfw to show an
          # OpenGL window, so we can't run it here.
          #CanvasCreation.ipynb
          Canvas-Overview.ipynb
          #Drawing-Texts.ipynb  # Segfaults. TODO find the crash
          #Paint-Overview.ipynb  # skia.Image.DecodeToRaster missing
          Path-Overview.ipynb
          #Python-Image-IO.ipynb  # Hardcoded reference to ../skia/resources
          Showcase.ipynb
        )
        for notebook in "''${notebooks[@]}" ; do
          echo "Executing $notebook"
          ${execnb}/bin/exec_nb --dest $out/$notebook --exc_stop ${src}/notebooks/$notebook
        done
      '';
    }) { };

  meta = with lib; {
    description = "Python bindings to the Skia graphics library";
    homepage = "https://github.com/kyamagu/skia-python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ danc86 ];
  };
}

