{ stdenv, lib, fetchFromGitHub, bc, curl, figlet, fortune, gawk, iproute2, procps }:

stdenv.mkDerivation rec {
  pname = "fancy-motd";
  version = "unstable-2021-07-15";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = pname;
    rev = "e8d2d2602d9b9fbc132ddc4f9fbf22428d715721";
    sha256 = "10fxr1grsiwvdc5m2wd4n51lvz0zd4sldg9rzviaim18nw68gdq3";
  };

  buildInputs = [ bc curl figlet fortune gawk iproute2 ];

  postPatch = ''
    substituteInPlace motd.sh \
      --replace 'BASE_DIR="$(dirname "$(readlink -f "$0")")"' "BASE_DIR=\"$out/lib\""

    substituteInPlace modules/20-uptime \
      --replace "uptime -p" "${procps}/bin/uptime -p"

    # does not work on nixos
    rm modules/41-updates
  '';

  installPhase = ''
    runHook preInstall

    install -D motd.sh $out/bin/motd

    install -D framework.sh $out/lib/framework.sh
    install -D config.sh.example $out/lib/config.sh
    find modules -type f -exec install -D {} $out/lib/{} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fancy, colorful MOTD written in bash. Server status at a glance.";
    homepage = "https://github.com/bcyran/fancy-motd";
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
    platforms = platforms.linux;
    mainProgram = "motd";
  };
}
