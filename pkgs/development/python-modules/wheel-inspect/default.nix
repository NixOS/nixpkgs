{ lib
, buildPythonPackage
, fetchurl
, bleach, docutils, pygments, six
, attrs, entry-points-txt, headerparser, packaging, wheel-filename
}:

# wheel-filename is stuck on readme_renderer~=24.0.0, but the upstream is at a
# future version.
let readme_renderer_24 = buildPythonPackage rec {
  pname = "readme_renderer";
  version = "24.0.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/c3/7e/d1aae793900f36b097cbfcc5e70eef82b5b56423a6c52a36dce51fedd8f0/readme_renderer-24.0-py2.py3-none-any.whl";
    sha256 = "c8532b79afc0375a85f10433eca157d6b50f7d6990f337fa498c96cd4bfc203d";
  };

  doCheck = false;

  buildInputs = [
    bleach
    docutils
    pygments
    six
  ];

  meta = with lib; {
    description = "Python library for rendering readme descriptions";
    homepage = "https://github.com/pypa/readme_renderer";
    license = with licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
};

in buildPythonPackage rec {
  version = "1.7.0";
  pname = "wheel-inspect";
  format = "wheel";

  src = fetchurl {
    url = "https://github.com/jwodder/wheel-inspect/releases/download/v1.7.0/wheel_inspect-1.7.0-py3-none-any.whl";
    sha256 = "69b34de1f4464ddfc76280c4563e4afc644de2c88e3ae6882f030afdad3d73e4";
  };

  propagatedBuildInputs = [
    attrs
    bleach
    docutils
    entry-points-txt
    headerparser
    packaging
    pygments
    readme_renderer_24
    wheel-filename
  ];

  meta = with lib; {
    homepage = "https://github.com/jwodder/wheel-inspect";
    description = "Extract information from wheels";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
