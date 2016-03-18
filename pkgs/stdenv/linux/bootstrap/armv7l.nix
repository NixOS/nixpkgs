{
  busybox = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap/armv7l/busybox;
    sha256 = "1279nlh3x93fqpcxi98zycmn3jhly40pab63fwq41ygkna14vw6b";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://nixos-arm.dezgeg.me/bootstrap/armv7l/bootstrap-tools.tar.xz;
    sha256 = "15sdnsk5dc3qz27p7c4iainziz8f3r7xpg69dpfwfdaq1drw6678";
  };
}
