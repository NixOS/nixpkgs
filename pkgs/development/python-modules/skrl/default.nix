{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, gym
, gymnasium
, torch
, tensorboard
, tqdm
, wandb
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "skrl";
  version = "1.0.0";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Toni-SM";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-89OoJanmaB74SLF1qMI8WFBdN1czS7Yr7BmojaRdo4M=";
  };

  nativeBuildInputs = [ setuptools ];

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
