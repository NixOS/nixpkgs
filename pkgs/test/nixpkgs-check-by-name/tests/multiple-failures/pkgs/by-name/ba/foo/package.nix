{ someDrv }: someDrv // {
  escape = /bar;
  escape = ../.;
  nixPath = <nixpkgs>;
  pathWithSubexpr = ./${"test"};
}
