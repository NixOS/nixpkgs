{ stdenv, python }:

let
  p = python.override {
    packageOverrides = self: super: {
      astroid = super.astroid.overridePythonAttrs (oldAttrs: rec {
        version = "1.4.9";
        name = "${oldAttrs.pname}-${version}";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "a483e7891ce3a06dadfc6cb9095b0938aca58940d43576d72e4502b480c085d7";
        };
      });
      pylint = super.pylint.overridePythonAttrs (oldAttrs: rec {
        version = "1.6.5";
        name = "${oldAttrs.pname}-${version}";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "a673984a8dd78e4a8b8cfdee5359a1309d833cf38405008f4a249994a8456719";
        };
      });
    };
  };

in p.pkgs.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "0.26.1";
  pname = "conan";

  src = p.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "2da5a140a74d912d5561698b8cc5a5e5583b9dbe36623c59b4ce4be586476e7c";
  };

  propagatedBuildInputs = with p.pkgs; [
    requests fasteners pyyaml pyjwt colorama patch
    bottle pluginbase six distro pylint node-semver
    future pygments mccabe
  ];

  # enable tests once all of these pythonPackages available:
  # [ nose nose_parameterized mock WebTest codecov ]
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://conan.io;
    description = "Decentralized and portable C/C++ package manager";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
