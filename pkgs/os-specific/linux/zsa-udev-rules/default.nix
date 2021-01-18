{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "zsa-udev-rules";
  version = "unstable-2020-12-16";

  # TODO: use version and source from nixpkgs/pkgs/development/tools/wally-cli/default.nix after next release
  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "e5dde3c700beab39fb941c6941e55535bf9b2af6";
    sha256 = "0pkybi32r1hrmpa1mc8qlzhv7xy5n5rr5ah25lbr0cipp1bda417";
  };

  # it only installs files
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp dist/linux64/50-oryx.rules $out/lib/udev/rules.d/
    cp dist/linux64/50-wally.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "udev rules for ZSA devices";
    license = licenses.mit;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
    homepage = "https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file";
  };
}
