{
  lib,
  python3,
  writeText,
}:

let
  py = python3.pkgs;
in
py.toPythonApplication (
  py.mlflow.overridePythonAttrs (old: rec {

    propagatedBuildInputs = old.propagatedBuildInputs ++ [
      py.boto3
      py.mysqlclient
    ];

    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace mlflow/utils/process.py --replace \
          "child = subprocess.Popen(cmd, env=cmd_env, cwd=cwd, universal_newlines=True," \
          "cmd[0]='$out/bin/gunicornMlflow'; child = subprocess.Popen(cmd, env=cmd_env, cwd=cwd, universal_newlines=True,"
      '';

    gunicornScript = writeText "gunicornMlflow" ''
      #!/usr/bin/env python
      import re
      import sys
      from gunicorn.app.wsgiapp import run
      if __name__ == '__main__':
        sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', ''', sys.argv[0])
        sys.exit(run())
    '';

    postInstall = ''
      gpath=$out/bin/gunicornMlflow
      cp ${gunicornScript} $gpath
      chmod 555 $gpath
    '';
  })
)
