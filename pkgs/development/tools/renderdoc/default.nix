{ lib
, fetchFromGitHub
, nix-update-script
, cmake
, pkg-config
, mkDerivation
, qtbase
, qtx11extras
, qtsvg
, makeWrapper
, vulkan-loader
, libglvnd
, xorg
, python311
, python311Packages
, bison
, pcre
, automake
, autoconf
, addDriverRunpath
, waylandSupport ? false
, wayland
}:
let
  custom_swig = fetchFromGitHub {
    owner = "baldurk";
    repo = "swig";
    rev = "renderdoc-modified-7";
    sha256 = "15r2m5kcs0id64pa2fsw58qll3jyh71jzc04wy20pgsh2326zis6";
  };
in
mkDerivation rec {
  pname = "renderdoc";
  version = "1.34";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "v${version}";
    sha256 = "sha256-obRCILzMR7tCni0YoT3/oesTSADGI2sXqY3G6RS1h1o=";
  };

  buildInputs = [
    qtbase qtsvg xorg.libpthreadstubs xorg.libXdmcp qtx11extras vulkan-loader python311
  ] ++ (with python311Packages; [
    pyside2 pyside2-tools shiboken2
  ])
  ++ lib.optional waylandSupport wayland;

  nativeBuildInputs = [ cmake makeWrapper pkg-config bison pcre automake autoconf addDriverRunpath ];

  postUnpack = ''
    cp -r ${custom_swig} swig
    chmod -R +w swig
    patchShebangs swig/autogen.sh
  '';

  cmakeFlags = [
    (lib.cmakeFeature "BUILD_VERSION_HASH" src.rev)
    (lib.cmakeFeature "BUILD_VERSION_DIST_NAME" "NixOS")
    (lib.cmakeFeature "BUILD_VERSION_DIST_VER" version)
    (lib.cmakeFeature "BUILD_VERSION_DIST_CONTACT" "https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/graphics/renderdoc")
    (lib.cmakeBool "BUILD_VERSION_STABLE" true)
    (lib.cmakeBool "ENABLE_WAYLAND" waylandSupport)
  ];

  # TODO: define these in the above array via placeholders, once those are widely supported
  preConfigure = ''
    cmakeFlags+=" -DVULKAN_LAYER_FOLDER=$out/share/vulkan/implicit_layer.d/"
    cmakeFlags+=" -DRENDERDOC_SWIG_PACKAGE=$PWD/../swig"
  '';

  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/qrenderdoc --suffix LD_LIBRARY_PATH : "$out/lib:${vulkan-loader}/lib:${libglvnd}/lib"
    wrapProgram $out/bin/renderdoccmd --suffix LD_LIBRARY_PATH : "$out/lib:${vulkan-loader}/lib:${libglvnd}/lib"
  '';

  # The only documentation for this so far is in pkgs/build-support/add-opengl-runpath/setup-hook.sh
  postFixup = ''
    addDriverRunpath $out/lib/librenderdoc.so
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Single-frame graphics debugger";
    homepage = "https://renderdoc.org/";
    license = licenses.mit;
    longDescription = ''
      RenderDoc is a free MIT licensed stand-alone graphics debugger that
      allows quick and easy single-frame capture and detailed introspection
      of any application using Vulkan, D3D11, OpenGL or D3D12 across
      Windows 7 - 10, Linux or Android.
    '';
    maintainers = [ ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
