{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mov-cli";
  version = "unstable-2022-06-30";

  src = fetchFromGitHub {
    owner = "mov-cli";
    repo = "mov-cli";
    rev = "b89e807e8ffc830b0b18c8e98712441c03774b8e";
    sha256 = "sha256-D+OeXcLdkbG4ASbPQYIWf7J1CRZ9jH3UXxfTL4WleY0=";
  };

  propagatedBuildInputs = with python3.pkgs; [ setuptools httpx click beautifulsoup4 colorama ];

  postPatch = ''
    substituteInPlace setup.py --replace "bs4" "beautifulsoup4"
  '';

  meta = with lib; {
    homepage = "https://github.com/mov-cli/mov-cli";
    description = "A cli tool to browse and watch movies";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ baitinq ];
  };
}
