{ stdenv, python }:
let

  localPython = python.override {
    packageOverrides = self: super: rec {
      cement = super.cement.overridePythonAttrs (oldAttrs: rec {
        version = "2.8.2";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "1li2whjzfhbpg6fjb6r1r92fb3967p1xv6hqs3j787865h2ysrc7";
        };
      });

      colorama = super.colorama.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.7";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0avqkn6362v7k2kg3afb35g4sfdvixjgy890clip4q174p9whhz0";
        };
      });

      docker = super.docker.overridePythonAttrs (oldAttrs: rec {
          pname = "docker-py";
          version = "1.7.2";
          name = "${pname}-${version}";

          src = super.fetchPypi {
            inherit pname version;
            sha256 = "0k6hm3vmqh1d3wr9rryyif5n4rzvcffdlb1k4jvzp7g4996d3ccm";
          };
        });

      pathspec = super.pathspec.overridePythonAttrs (oldAttrs: rec {
        version = "0.5.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "07yx1gxj9v1iyyiy5fhq2wsmh4qfbrx158wi7jb0nx6lah80ffma";
        };
      });

      requests = super.requests.overridePythonAttrs (oldAttrs: rec {
        version = "2.9.1";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "0zsqrzlybf25xscgi7ja4s48y2abf9wvjkn47wh984qgs1fq2xy5";
        };
      });

      semantic-version = super.semantic-version.overridePythonAttrs (oldAttrs: rec {
        version = "2.5.0";

        src = super.fetchPypi {
          inherit (oldAttrs) pname; inherit version;
          sha256 = "0p5n3d6blgkncxdz00yxqav0cis87fisdkirjm0ljjh7rdfx7aiv";
        };
      });

      tabulate = super.tabulate.overridePythonAttrs (oldAttrs: rec {
        version = "0.7.5";

        src = super.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "03l1r7ddd1a0j2snv1yd0hlnghjad3fg1an1jr8936ksv75slwch";
        };
      });
    };
  };
in with localPython.pkgs; buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "awsebcli";
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ljras4bgxpmk1l3plialmhi7jsm2cpzx0dcs9411ijykzkamdkd";
  };

  checkInputs = [
    pytest mock nose pathspec colorama requests docutils
  ];

  doCheck = false;

  propagatedBuildInputs = [
    blessed botocore cement colorama docker dockerpty docopt pathspec pyyaml
    requests semantic-version setuptools tabulate termcolor websocket_client
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    mv $out/bin/eb_completion.bash $out/etc/bash_completion.d
  '';

  meta = with stdenv.lib; {
    homepage = http://aws.amazon.com/elasticbeanstalk/;
    description = "A command line interface for Elastic Beanstalk.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.asl20;
  };
}
