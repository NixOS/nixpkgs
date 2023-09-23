{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "baboossh";
  version = "1.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cybiere";
    repo = "baboossh";
    rev = "refs/tags/v${version}";
    hash = "sha256-dorIqnJuAS/y9W6gyt65QjwGwx4bJHKLmdqRPzY25yA=";
  };

  # https://github.com/cybiere/baboossh/issues/11
  postPatch = let
    py3compat-u-implementation = ''
      def u(s, encoding="utf8"):
        if isinstance(s, bytes): return s.decode(encoding)
        elif isinstance(s, str): return s
        else: raise TypeError("Expected unicode or bytes, got {!r}".format(s))
    '';
  in ''
    py3compat_fnames=(
      baboossh/connection.py
      baboossh/ext_dir/payload_exec.py
      baboossh/ext_dir/payload_shell.py
      baboossh/ext_dir/payload_gather.py
    )
    substituteInPlace "''${py3compat_fnames[@]}" \
      --replace "from paramiko.py3compat import u" '${py3compat-u-implementation}'
  '';

  propagatedBuildInputs = with python3.pkgs; [
    cmd2
    tabulate
    paramiko
    python-libnmap
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [
    "baboossh"
  ];

  meta = with lib; {
    description = "Tool to do SSH spreading";
    homepage = "https://github.com/cybiere/baboossh";
    changelog = "https://github.com/cybiere/baboossh/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
