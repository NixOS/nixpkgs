{ lib, buildPythonPackage, fetchPypi, fetchurl, fetchzip, jsonschema
, wcmatch, click, ruamel-yaml, click-option-group, boltons, tqdm, glom, requests
, colorama, defusedxml, packaging, peewee, setuptools }:

let
  version = "0.92.0";

  # semgrep engine is written in OCaml and sources are present in
  # https://github.com/returntocorp/semgrep, but I failed to build it.
  #
  # It looks like dypgen required ocaml <= 4.06 and atdgen ocaml >= 4.08.
  #
  # Clearly, I don't understand something, and this can and should be done
  # properly. In mean time, I cheat and download upstream-provided static
  # binary. That constraints derivation to x86_64 architecture.
  #
  # 2022-05-12 ~kaction
  semgrep-core = fetchzip {
    url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-ubuntu-16.04.tgz";
    sha256 = "01zn4xihzgwvyadfqzk8r1ngihsx6m4m1wrfyzady8h1x11v877a";
    stripRoot = false;
    extraPostFetch = ''
      mv $out/semgrep-files $out/bin
    '';
  };

in buildPythonPackage rec {
  pname = "semgrep";
  inherit version;

  # FIXME: This is also cheating, should fetch from github.
  src = fetchPypi {
    inherit pname version;
    sha256 = "1nsfk7dkfl6ddqvrsrc1afhjlpj7mfcii5svljh286v6i0nf25sx";
  };

  postPatch = ''
    substituteInPlace setup.py                \
      --replace 'jsonschema~=' 'jsonschema>=' \
      --replace 'boltons~=' 'boltons<='
  '';

  # Upstream insists that `semgrep-core` is present in build environment, hence
  # it must be in nativeBuildInputs. But really it is propagated runtime
  # dependency.
  nativeBuildInputs = [ semgrep-core ];

  propagatedBuildInputs = [
    semgrep-core

    boltons
    click
    click-option-group
    colorama
    defusedxml
    glom
    jsonschema
    packaging
    peewee
    requests
    ruamel-yaml
    setuptools
    tqdm
    wcmatch
  ];

  pythonImportsCheck = [ "semgrep" ];

  meta = with lib; {
    homepage = "https://github.com/returntocorp/semgrep";
    description = "Lightweight static analysis for many languages.";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ kaction ];
    platforms = [ "x86_64-linux" ];
  };
}
