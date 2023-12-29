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
, python3
, python3Packages
, bison
, pcre
, automake
, autoconf
, addOpenGLRunpath
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
  cmakeBool = b: if b then "ON" else "OFF";
in
mkDerivation rec {
  pname = "renderdoc";
  version = "1.29";

  src = fetchFromGitHub {
    owner = "baldurk";
    repo = "renderdoc";
    rev = "v${version}";
    sha256 = "sha256-ViZMAuqbXN7upyVLc4arQy2EASHeoYViMGpCwZPEWuo=";
  };

  buildInputs = [
    qtbase qtsvg xorg.libpthreadstubs xorg.libXdmcp qtx11extras vulkan-loader python3
  ] ++ (with python3Packages; [
    pyside2 pyside2-tools shiboken2
  ])
  ++ lib.optional waylandSupport wayland;

  nativeBuildInputs = [ cmake makeWrapper pkg-config bison pcre automake autoconf addOpenGLRunpath ];

  postUnpack = ''
    cp -r ${custom_swig} swig
    chmod -R +w swig
    patchShebangs swig/autogen.sh
  '';

  cmakeFlags = [
    "-DBUILD_VERSION_HASH=${src.rev}"
    "-DBUILD_VERSION_DIST_NAME=NixOS"
    "-DBUILD_VERSION_DIST_VER=${version}"
    "-DBUILD_VERSION_DIST_CONTACT=https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/graphics/renderdoc"
    "-DBUILD_VERSION_STABLE=ON"
    "-DENABLE_WAYLAND=${cmakeBool waylandSupport}"
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
    addOpenGLRunpath $out/lib/librenderdoc.so
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A single-frame graphics debugger";
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
