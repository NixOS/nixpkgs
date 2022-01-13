{ stdenv, lib, callPackage, wineWayland, pkgArches, pulseaudioSupport, vulkanSupport, vkd3dSupport }:

with callPackage ./util.nix {};

(wineWayland.overrideAttrs (old: rec {
  name = "${old.name}-wayland";

  buildInputs = (toBuildInputs pkgArches (pkgs: [ pkgs.wayland pkgs.libxkbcommon pkgs.wayland-protocols pkgs.wayland.dev pkgs.libxkbcommon.dev ])) ++ (lib.subtractLists (toBuildInputs pkgArches (pkgs: [ pkgs.xorg.libX11 pkgs.xorg.libXi pkgs.xorg.libXcursor pkgs.xorg.libXrandr pkgs.xorg.libXrender pkgs.xorg.libXxf86vm pkgs.xorg.libXcomposite pkgs.xorg.libXext ])) old.buildInputs);

  NIX_LDFLAGS = toString (map (path: "-rpath " + path) (
    map (x: "${lib.getLib x}/lib") ([ stdenv.cc.cc ] ++ buildInputs)
    # libpulsecommon.so is linked but not found otherwise
    ++ lib.optionals pulseaudioSupport (map (x: "${lib.getLib x}/lib/pulseaudio")
        (toBuildInputs pkgArches (pkgs: [ pkgs.libpulseaudio ])))
    ++ (map (x: "${lib.getLib x}/share/wayland-protocols")
        (toBuildInputs pkgArches (pkgs: [ pkgs.wayland-protocols ])))
  ));

  configureFlags = old.configureFlags
    ++ [ "--with-wayland" ]
    ++ lib.optionals vulkanSupport [ "--with-vulkan" ]
    ++ lib.optionals vkd3dSupport [ "--with-vkd3d" ];


    meta = old.meta // {
      description = "An Open Source implementation of the Windows API on top of OpenGL and Unix (with experimental Wayland support)";
      platforms = (lib.remove "x86_64-darwin" old.meta.platforms);
      maintainers = old.meta.maintainers ++ [ lib.maintainers.jmc-figueira ];
    };
}))
