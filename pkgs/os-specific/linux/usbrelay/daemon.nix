{ stdenv, usbrelay, python3 }:
let
  python = python3.withPackages (ps: with ps; [ usbrelay-py paho-mqtt ]);
in
# This is a separate derivation, not just an additional output of
# usbrelay, because otherwise, we have a cyclic dependency between
# usbrelay (default.nix) and the python module (python.nix).
stdenv.mkDerivation rec {
  pname = "usbrelayd";

  inherit (usbrelay) src version;

  postPatch = ''
    substituteInPlace 'usbrelayd.service' \
      --replace '/usr/bin/python3' "${python}/bin/python3" \
      --replace '/usr/sbin/usbrelayd' "$out/bin/usbrelayd"
  '';

  buildInputs = [ python ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall;
    install -m 644 -D usbrelayd $out/bin/usbrelayd
    install -m 644 -D usbrelayd.service $out/lib/systemd/system/usbrelayd.service
    install -m 644 -D 50-usbrelay.rules $out/lib/udev/rules.d/50-usbrelay.rules
    install -m 644 -D usbrelayd.conf $out/etc/usbrelayd.conf # include this as an example
    runHook postInstall
  '';

  meta = {
    description = "USB Relay MQTT service";
    inherit (usbrelay.meta) homepage license maintainers platforms;
  };
}
