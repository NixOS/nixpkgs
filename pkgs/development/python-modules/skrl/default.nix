{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, pytestCheckHook
, gym
, gymnasium
, torch
, tensorboard
, tqdm
, wandb
, packaging
}:

buildPythonPackage rec {
  pname = "skrl";
  version = "0.10.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Toni-SM";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-OY5+bUPg+G1eKFMvHlXSHwc2WWHTpyoyCKjY3MvlLyM=";
  };

  patches = [
    # remove after next release:
    (fetchpatch {
       name = "fix-python_requires-specification";
       url = "https://github.com/Toni-SM/skrl/pull/62/commits/9b554adfe2da6cd97cccbbcd418a349cc8f1de80.patch";
       hash = "sha256-GeASMU1Pgy8U1zaIAVroBDjYaY+n93XP5uFyP4U9lok=";
    })
  ];

  propagatedBuildInputs = [
    gym
    gymnasium
    torch
    tensorboard
    tqdm
    wandb
    packaging
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  doCheck = torch.cudaSupport;

  pythonImportsCheck = [
    "skrl"
    "skrl.agents"
    "skrl.agents.torch"
    "skrl.envs"
    "skrl.envs.torch"
    "skrl.models"
    "skrl.models.torch"
    "skrl.resources"
    "skrl.resources.noises"
    "skrl.resources.noises.torch"
    "skrl.resources.schedulers"
    "skrl.resources.schedulers.torch"
    "skrl.trainers"
    "skrl.trainers.torch"
    "skrl.utils"
    "skrl.utils.model_instantiators"
  ];

  meta = with lib; {
    description = "Reinforcement learning library using PyTorch focusing on readability and simplicity";
    homepage = "https://skrl.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
