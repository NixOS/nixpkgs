{ stdenv, lib, fetchFromGitHub, bc, curl, figlet, fortune, gawk, iproute2, lm_sensors, procps }:

stdenv.mkDerivation rec {
  pname = "fancy-motd";
  version = "unstable-2022-11-08";

  src = fetchFromGitHub {
    owner = "bcyran";
    repo = pname;
    rev = "1573a60d780ff12f03dbff602ceaf97755910079";
    sha256 = "sha256-mPd2aum/wsdlvEhjikeJNwZN/BArwX4h0VQROF925hg=";
  };

  buildInputs = [ bc curl figlet fortune gawk iproute2 lm_sensors ];

  postPatch = ''
    substituteInPlace motd.sh \
      --replace 'BASE_DIR=$(dirname "$(readlink -f "$0")")' "BASE_DIR=\"$out/lib\""

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
