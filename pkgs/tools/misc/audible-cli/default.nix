{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "audible-cli";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-KPuAY/QMO2029tD4DMGCwmKuqpnxXAALYT+wE1ApfsI=";
  };

  propagatedBuildInputs = with python3Packages; [ aiofiles audible click httpx pillow tabulate toml tqdm packaging setuptools questionary ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpx>=0.20.0,<0.24.0" "httpx" \
      --replace "audible>=0.8.2" "audible"
  '';

  meta = with lib; {
    description = "A command line interface for audible package. With the cli you can download your Audible books, cover, chapter files";
    license = licenses.agpl3;
    homepage = "https://github.com/mkb79/audible-cli";
    maintainers = with maintainers; [ jvanbruegge ];
  };
}
