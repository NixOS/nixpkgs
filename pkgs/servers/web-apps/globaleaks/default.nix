{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3,
  buildNpmPackage,
  nodePackages,
  pkg-config,
  pixman,
  cairo,
  pango,
}: let
  python = python3.override {
    packageOverrides = self: super: {
      sqlalchemy = super.sqlalchemy.overridePythonAttrs rec {
        version = "1.4.46";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-aRO4JH2KKS74MVFipRkx4rQM6RaB8bbxj2lwRSAMSjA=";
        };
        disabledTestPaths = [];
      };
    };
  };

  pname = "globaleaks";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "globaleaks";
    repo = "GlobaLeaks";
    rev = "v${version}";
    hash = "sha256-+eYD+nPqmAxGCaQUNewMzmSX0lw4OivIv1PSnHvZUxQ=";
  };

  meta = with lib; {
    description = "GlobaLeaks is free, open source software enabling anyone to easily set up and maintain a secure whistleblowing platform. ";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [andresnav];
  };

  clientPackage = buildNpmPackage {
    pname = "${pname}-client";
    inherit version src meta;

    sourceRoot = "${src.name}/client";

    # Errro with conflicting versions of stylelint, using `15.10.2`.
    postPatch = ''
      substituteInPlace npm-shrinkwrap.json \
      --replace '"stylelint": "15.10.3",' '"stylelint": "15.10.2",'

      substituteInPlace package.json \
      --replace '"stylelint": "15.10.3",' '"stylelint": "15.10.2",'

      ln -s npm-shrinkwrap.json package-lock.json
    '';

    nativeBuildInputs = [
      nodePackages.node-gyp
      python
      pkg-config
    ];

    buildInputs = [
      pixman
      cairo
      pango
    ];

    env = {
      CYPRESS_INSTALL_BINARY = 0; # cypress tries to download binaries otherwise
    };

    npmDepsHash = "sha256-GgPa9zIVqI/YQmO5xpi6qmabWpQOlpV2Du2TuKJPBVQ=";

    buildPhase = ''
      runHook preBuild

      node_modules/grunt/bin/grunt build

      runHook postBuild
    '';
  };
in
  python.pkgs.buildPythonApplication rec {
    inherit pname version src meta;

    sourceRoot = "${src.name}/backend";

    propagatedBuildInputs = with python.pkgs; [
      twisted
      h2
      priority
      sqlalchemy
      pyotp
      cryptography
      pynacl
      acme
      python-gnupg
      service-identity
      debian
      txtorcon
      clientPackage
    ];

    # Done so globaleaks can recognize where the client is built
    postPatch = ''
      substituteInPlace globaleaks/settings.py \
      --replace '/usr/share/globaleaks/client/' '${clientPackage}/lib/node_modules/GlobaLeaks/build'
    '';

    postInstall = ''
      find $out -name "__pycache__" -type d | xargs rm -rv
    '';
  }
