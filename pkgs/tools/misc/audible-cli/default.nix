{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "audible-cli";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = pname;
    rev = "v${version}";
    sha256 = "0i71vwq2bhndndb0mlx21bc5jkv75cr60max5iaxk23agg3xpgwv";
  };

  propagatedBuildInputs = with python3Packages; [ aiofiles audible click httpx pillow tabulate toml tqdm packaging setuptools ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpx==0.20.*" "httpx" \
      --replace "audible==0.7.2" "audible"
  '';

  meta = with lib; {
    description = "A command line interface for audible package. With the cli you can download your Audible books, cover, chapter files";
    license = licenses.agpl3;
    homepage = "https://github.com/mkb79/audible-cli";
    maintainers = with maintainers; [ jvanbruegge ];
  };
}
