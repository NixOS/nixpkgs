{ lib, rustPlatform, fetchFromGitLab, pkg-config, udev, kmod }:

rustPlatform.buildRustPackage rec {
  pname = "supergfxctl";
  version = "2.0.5";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = pname;
    rev = version;
    sha256 = "0qb7ysvbdk0jl26z5z887wf6zq0bsz3991hk2jbp4cxbifd2j8ph";
  };

  patches = [
    ./no-config-write.patch
  ];

  postPatch = ''
    substituteInPlace data/supergfxd.service \
      --replace /usr/bin $out/bin

    substituteInPlace src/controller.rs \
      --replace \"modprobe\" \"${kmod}/bin/modprobe\" \
      --replace \"rmmod\" \"${kmod}/bin/rmmod\"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

  cargoHash = "sha256-qT6XRcfx9Zu0PnBxeTeqKv+PiX6tXJpJBdhSr7TjtXk=";

  makeFlags = [ "prefix=${placeholder "out"}" ];
  # Use default phases since the build scripts install systemd services and udev rules too
  buildPhase = "buildPhase";
  installPhase = "installPhase";

  meta = with lib; {
    description = "Graphics switching tool";
    homepage = "https://gitlab.com/asus-linux/supergfxctl";
    license = licenses.mpl20;
    maintainers = [ maintainers.Cogitri ];
  };
}
