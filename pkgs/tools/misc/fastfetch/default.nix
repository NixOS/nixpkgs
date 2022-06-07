{ chafa
, cmake
, dbus
, dconf
, fetchFromGitHub
, glib
, imagemagick_light
, lib
, libglvnd
, libxcb
, makeWrapper
, ocl-icd
, opencl-headers
, pciutils
, pkg-config
, stdenv
, vulkan-loader
, wayland
, xfce
, xorg
, zlib
, enableChafa ? false
, enableImageMagick ? false
, enableOpenCLModule ? true
, enableOpenGLModule ? true
, enableVulkanModule ? true
, enableWayland ? true
, enableX11 ? true
, enableXFCE ? false
}:

stdenv.mkDerivation rec {
  pname = "fastfetch";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "LinusDierheimer";
    repo = pname;
    rev = version;
    hash = "sha256-OsK78irfO9r6pSEmlN6mFoKhQZgBqIYO8syj5AHH4IE=";
  };

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];

  runtimeDependencies =
    [
      dbus
      dconf
      glib
      pciutils
      zlib
    ]
    ++ lib.optionals (enableChafa) [ chafa ]
    ++ lib.optionals (enableImageMagick) [ imagemagick_light ]
    ++ lib.optionals (enableOpenCLModule) [ ocl-icd ]
    ++ lib.optionals (enableOpenGLModule) [ libglvnd ]
    ++ lib.optionals (enableVulkanModule) [ vulkan-loader ]
    ++ lib.optionals (enableWayland) [ wayland ]
    ++ lib.optionals (enableX11) [ libxcb ]
    ++ lib.optionals (enableXFCE) [ xfce.xfconf ];

  buildInputs =
    runtimeDependencies
    ++ lib.optionals (enableOpenCLModule) [ opencl-headers ]
    ++ lib.optionals (enableX11) [ xorg.libX11 ];

  LD_LIBRARY_PATH = lib.makeLibraryPath runtimeDependencies;

  postInstall = ''
    wrapProgram $out/bin/fastfetch --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
    wrapProgram $out/bin/flashfetch --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
  '';

  meta = with lib; {
    description = "Like neofetch, but much faster";
    homepage = "https://github.com/LinusDierheimer/fastfetch";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yureien ];
  };
}
