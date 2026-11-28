{
  version = "2026.4";

  minKernelVersion = "5.18";

  # To get these, run:
  #
  # ```
  # for tool in alfred batctl batman-adv; do nix-prefetch-url https://downloads.open-mesh.org/batman/releases/batman-adv-2026.4/$tool-2026.4.tar.gz --type sha256 | xargs nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri; done
  # ```
  sha256 = {
    alfred = "sha256-nR9ceEYI0Pjw26W0YB9cPFzR7etsZx/jISsI+FX9cKk=";
    batctl = "sha256-otqlAdMGrPMGIZQiietlGi8XTyDnFPcDWdKfsyuqLTM=";
    batman-adv = "sha256-AihI5FDjrOKedRDu/A+Hbk98eAvVJzbvLIA1np4zOiA=";
  };
}
