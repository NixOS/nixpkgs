{ pkgs, jpegoptim, optipng }:

let
  inherit (pkgs.python3.pkgs) buildPythonApplication fetchPypi;
in
buildPythonApplication rec {
  pname = "sacad";
  version = "2.0.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vb2y18lmsm742pwff9164plbji3vjmx06accc84vws1nv7d1rzg";
  };

  doCheck = false;

  propagatedBuildInputs = with pkgs.python3.pkgs; [
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

  meta = {
    description = "Smart Automatic Cover Art Downloader";
    license = pkgs.stdenv.lib.licenses.mpl20;
    homepage = https://github.com/desbma/sacad;
    maintainers = with pkgs.stdenv.lib.maintainers; [ ayyjayess ];
  };
}
