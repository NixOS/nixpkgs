{ lib
, stdenv
, fetchFromGitea
, bash
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "game-devices-udev-rules";
  version = "0.22";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fabiscafe";
    repo = "game-devices-udev";
    rev = finalAttrs.version;
    hash = "sha256-1aOb8pJxB+/PM7spcvZcy/cwdEolHQ4+lwBLij+6iDk=";
  };

  postInstall = ''
    install -Dm444 -t "$out/lib/udev/rules.d" *.rules
    substituteInPlace $out/lib/udev/rules.d/71-powera-controllers.rules \
    --replace "/bin/sh" "${bash}/bin/bash"
  '';

  meta = with lib; {
    description = "Udev rules to make supported controllers available with user-grade permissions";
    homepage = "https://codeberg.org/fabiscafe/game-devices-udev";
    license = licenses.mit;
    longDescription = ''
      These udev rules are intended to be used as a package under 'services.udev.packages'.
      They will not be activated if installed as 'environment.systemPackages' or 'users.user.<user>.packages'.

      Additionally, you may need to enable 'hardware.uinput'.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ keenanweaver ];
  };
})
