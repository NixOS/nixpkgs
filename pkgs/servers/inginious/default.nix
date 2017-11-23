{ pkgs, lib, python2Packages }:
with lib;
with python2Packages;

let
  # Alias back to the original names
  PyYAML = pyyaml;
  msgpack-python = msgpack;
  pytidylib = tidylib;

  docker-py = docker.overrideAttrs (oldAttrs: rec {
    pname = "docker-py";
    version = "1.10.6";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "05f49f6hnl7npmi7kigg0ibqk8s3fhzx1ivvz1kqvlv4ay3paajc";
    };
  });

  web-py = web.overrideAttrs (oldAttrs: rec {
    pname = "web.py";
    version = "0.40.dev0";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "18v91c4s683r7a797a8k9p56r1avwplbbcb3l6lc746xgj6zlr6l";
    };
  });

  sphinx-rtd-theme = buildPythonPackage rec {
    pname = "sphinx_rtd_theme";
    version = "0.2.4";
    name = "${pname}-${version}";

    src = fetchPypi {
      inherit pname version;
      sha256 = "05rlhjzdyapr2w74jjs7mrm8hi69qskcr5vya9f9drpsys7lpxrd";
    };
  };

in buildPythonApplication rec {
  version = "0.4.0";
  name = "inginious-${version}";

  disabled = isPy3k;

  propagatedBuildInputs = [
    docker-py #>=1.9.0
    docutils #>=0.12
    pymongo #>=3.2.2
    PyYAML #>=3.11",
    web-py #>=0.40.dev0",
    watchdog #>= 0.8.3",
    msgpack-python #>= 0.4.7",
    pyzmq #>= 15.3.0",
    natsort #>= 5.0.1",
    psutil #>= 4.4.2"
    oauth2 #>=1.9.0.post1
    httplib2 #>=0.9",
    six #>=1.10.0"
    # Doc stuff
    pytidylib #>=0.2.4",
    sphinx-rtd-theme #>=0.1.8"
    # ??
    sh #>=1.11
  ];

  buildInputs = [ nose selenium virtual-display ];

  src = pkgs.fetchFromGitHub {
    owner = "UCL-INGI";
    repo = "INGInious";
    rev = "v${version}";
    sha256 = "06p9nzz09n32v94ky4x1v65fafjhn5vvi3y4zak31w0jixmjy205";
  };

  # Only patch shebangs in /bin, other scripts are run within docker
  # containers and will fail if patched.
  dontPatchShebangs = true;
  preFixup = ''
    patchShebangs $prefix/bin
  '';

  doCheck = false;

  meta = {
    description = "An intelligent grader that allows secured and automated testing of code made by students";
    homepage = https://github.com/UCL-INGI/INGInious;
    license = licenses.agpl3;
    maintainers = with maintainers; [ layus ];
  };
}
