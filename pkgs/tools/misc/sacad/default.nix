{ stdenv, python3, jpegoptim, optipng }:
with python3.pkgs;
let
  inherit (python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "sacad";
  version = "2.0.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vb2y18lmsm742pwff9164plbji3vjmx06accc84vws1nv7d1rzg";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    appdirs
    cssselect
    lxml
    mutagen
    pillow
    tqdm
    web_cache
    jpegoptim
    optipng
  ];

  doCheck = false;

  meta = {
    description = "Smart Automatic Cover Art Downloader";
    license = stdenv.lib.licenses.mpl20;
    homepage = https://github.com/desbma/sacad;
    maintainers = with stdenv.lib.maintainers; [ ayyjayess ];
  };
}
