{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonPackage rec {
  pname = "maunium-stickerpicker";
  version = "master-2022-11-15";

  src = fetchFromGitHub {
    owner = "maunium";
    repo = "stickerpicker";
    rev = "f59406a47a6778cd402e656ffb64f667335f665a";
    sha256 = "sha256-5Kbok9vJIlOti+ikpJXv2skdADhQQTjX5mVmBTM0wGU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    python-magic
    cryptg
    telethon
    pillow
    yarl
    aiohttp
  ];

  doCheck = false; # Upstream has no tests

  postInstall = ''
    cp -r web $out/web
    cp packs/* $out/web/packs
  '';

  meta = with lib; {
    homepage = "https://github.com/maunium/stickerpicker";
    description = "A fast and simple Matrix sticker picker widget. Tested on Element Web, Android & iOS.";
    license = licenses.agpl3;
    platforms = platforms.linux;
  };
}

