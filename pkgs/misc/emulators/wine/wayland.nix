{ lib, callPackage, wineWayland, vulkanSupport, vkd3dSupport }:

with callPackage ./util.nix {};

(lib.overrideDerivation wineWayland (self: {
  buildInputs = (toBuildInputs wineWayland.pkgArches (pkgs: [ pkgs.wayland pkgs.libxkbcommon pkgs.wayland-protocols pkgs.wayland.dev pkgs.libxkbcommon.dev ])) ++ (lib.subtractLists (toBuildInputs wineWayland.pkgArches (pkgs: [ pkgs.xorg.libX11 pkgs.xorg.libXi pkgs.xorg.libXcursor pkgs.xorg.libXrandr pkgs.xorg.libXrender pkgs.xorg.libXxf86vm pkgs.xorg.libXcomposite pkgs.xorg.libXext ])) self.buildInputs);

  name = "${self.name}-wayland";

  configureFlags = self.configureFlags
    ++ [ "--with-wayland" ]
    ++ lib.optionals vulkanSupport [ "--with-vulkan" ]
    ++ lib.optionals vkd3dSupport [ "--with-vkd3d" ];

})) // {
  meta = wineWayland.meta // {
    description = "An Open Source implementation of the Windows API on top of OpenGL and Unix (with experimental Wayland support)";
    platforms = (lib.remove "x86_64-darwin" wineWayland.meta.platforms);
    maintainers = wineWayland.meta.maintainers ++ [ lib.maintainers.jmc-figueira ];
  };
}
