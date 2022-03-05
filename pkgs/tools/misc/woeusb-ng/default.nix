{ lib, python3Packages, fetchFromGitHub, p7zip, parted, grub2 }:
with python3Packages;

buildPythonApplication rec {
  pname = "woeusb-ng";
  version = "0.2.10";

  propagatedBuildInputs = [ p7zip parted grub2 termcolor wxPython_4_0 six ];

  src = fetchFromGitHub {
    owner = "WoeUSB";
    repo = "WoeUSB-ng";
    rev = "v${version}";
    sha256 = "sha256-Nsdk3SMRzj1fqLrp5Na5V3rRDMcIReL8uDb8K2GQNWI=";
  };

  postInstall = ''
    # TODO: the gui requires additional polkit-actions to work correctly, therefore it is currently disabled
    rm $out/bin/woeusbgui
  '';

  # checks fail, because of polkit-actions and should be reenabled when the gui is fixed.
  doCheck = false;

  meta = with lib; {
    description = "A tool to create a Windows USB stick installer from a real Windows DVD or image";
    homepage = "https://github.com/WoeUSB/WoeUSB-ng";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}
