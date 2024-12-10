with import ../../../.. { };
nixos-option.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    # hiprio so that it has a higher priority than the default unwrapped clang tools from clang if our stdenv is based on clang
    (lib.hiPrio pkgs.buildPackages.clang-tools)
  ];
})
