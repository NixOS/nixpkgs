{ lib
, python3
, fetchFromGitHub
}:
let
  py = python3.override {
    packageOverrides = final: prev: {
      # required for networkx 2.5.1
      decorator = prev.decorator.overridePythonAttrs (o: o // rec {
        version = "4.4.2";
        src = o.src.override {
          inherit version;
          hash = "sha256-46YvBSAXJEDKDcyCN0kxk4Ljd/N/FAoLme9F/suEv+c=";
        };
      });

      # flare-floss requires this exact version (newer versions are incompatible)
      networkx = prev.networkx.overridePythonAttrs (o: o // rec {
        version = "2.5.1";
        src = o.src.override {
          inherit version;
          hash = "sha256-EJzVhcrEEpf3EQPDxCrG73N58peI61TLdRvlpmO7I1o=";
        };
      });
    };
  };
in
py.pkgs.buildPythonPackage rec {
  pname = "flare-floss";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "mandiant";
    repo = "flare-floss";
    rev = "v${version}";
    fetchSubmodules = true; # for tests
    hash = "sha256-V4OWYcISyRdjf8x93B6h2hJwRgmRmk32hr8TrgRDu8Q=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "==" ">="

    substituteInPlace floss/main.py \
      --replace 'sigs_path = os.path.join(get_default_root(), "sigs")' 'sigs_path = "'"$out"'/share/flare-floss/sigs"'
  '';

  propagatedBuildInputs = with py.pkgs; [
    halo
    networkx
    pydantic
    tabulate
    tqdm
    viv-utils
    vivisect
  ] ++ viv-utils.optional-dependencies.flirt;

  nativeCheckInputs = with py.pkgs; [
    pytest-sugar
    pytestCheckHook
    pyyaml
  ];

  postInstall = ''
    mkdir -p $out/share/flare-floss/
    cp -r sigs $out/share/flare-floss/
  '';

  meta = with lib; {
    description = "Automatically extract obfuscated strings from malware";
    homepage = "https://github.com/mandiant/flare-floss";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
