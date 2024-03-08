{ someDrv }: someDrv // {
  escapeAbsolute = /bar;
  escapeRelative = ../.;
  nixPath = <nixpkgs>;
  pathWithSubexpr = ./${"test"};
}
