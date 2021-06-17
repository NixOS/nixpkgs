{ stdenv, lib, fetchFromGitHub, bc, curl, figlet, fortune, gawk, iproute2, procps }:

stdenv.mkDerivation rec {
  pname = "fancy-motd";
  version = "unstable-2021-05-20";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = pname;
    rev = "57978bdfa31179783c51c6f33e47063ec8641205";
    sha256 = "0bkgd86721jw81jvliw3rv4p52qpjynsxb6hn81divd068l56prg";
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
