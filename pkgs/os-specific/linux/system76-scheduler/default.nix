{ lib
, fetchFromGitHub
, rustPlatform
, pipewire
, pkg-config
, bcc
, dbus }:

let
  version = "2.0.1";
in rustPlatform.buildRustPackage {
  pname = "system76-scheduler";
  inherit version;
  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "system76-scheduler";
    rev = version;
    hash = "sha256-o4noaLBXHDe7pMBHfQ85uzKJzwbBE5mkWq8h9l6iIZs=";
  };
  cargoSha256 = "sha256-hpFDAhOzm4v3lBWwAl/10pS5xvKCScdKsp5wpCeQ+FE=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];
  buildInputs = [ dbus pipewire ];

  EXECSNOOP_PATH = "${bcc}/bin/execsnoop";

  # tests don't build
  doCheck = false;

  postInstall = ''
    mkdir -p $out/data
    install -D -m 0644 data/com.system76.Scheduler.conf $out/etc/dbus-1/system.d/com.system76.Scheduler.conf
    install -D -m 0644 data/*.kdl $out/data/
  '';

  meta = with lib; {
    description = "System76 Scheduler";
    homepage = "https://github.com/pop-os/system76-scheduler";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" "x86-linux" "aarch64-linux" ];
    maintainers = [ maintainers.cmm ];
  };
}
