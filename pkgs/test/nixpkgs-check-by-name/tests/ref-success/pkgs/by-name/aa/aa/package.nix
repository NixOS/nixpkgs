{ someDrv }: someDrv // {
  nixFile = ./file.nix;
  nonNixFile = ./file;
  directory = ./dir;
}
