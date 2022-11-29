{ lib
, poetry2nix
, python310
, fetchFromGitLab
, projectDir ? ./.
, pyproject ? projectDir + "/pyproject.toml"
, poetrylock ? projectDir + "/poetry.lock"
}:
  poetry2nix.mkPoetryApplication {
    preferWheels = true;

    inherit projectDir pyproject poetrylock;

    src = fetchFromGitLab {
      owner = "mchal_";
      repo = "nx";
      rev = "v1.0.0";
      sha256 = "sha256-Csr42RMrlG038AWB94iL5i48yUA7PeH7GIDGPqM1Dpg=";
    };

    python = python310;

    meta = with lib; {
      inherit (python310.meta) platforms;
      description = "A fast and beautiful NixOS and Nix management utility";
      homepage = "https://gitlab.com/mchal_/nx";
      license = licenses.gpl3;
      maintainers = with maintainers; [ not-my-segfault ];
    };
  }
