{ stdenv, lib, fetchFromGitHub, bc, curl, figlet, fortune, gawk, iproute2, procps }:

stdenv.mkDerivation rec {
  pname = "fancy-motd";
  version = "unstable-2021-06-27";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = pname;
    rev = "839320ab261612c9ba5b13fc8d1445d094ea0ab3";
    sha256 = "00wv7nk2f3q186z2qfks5salf97s04vk7ilk8jnbimxg4fl7hcda";
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
