{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  gym,
  gymnasium,
  torch,
  tensorboard,
  tqdm,
  wandb,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "skrl";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Toni-SM";
    repo = "skrl";
    tag = version;
    hash = "sha256-5lkoYAmMIWqK3+E3WxXMWS9zal2DhZkfl30EkrHKpdI=";
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

  meta = {
    description = "Reinforcement learning library using PyTorch focusing on readability and simplicity";
    changelog = "https://github.com/Toni-SM/skrl/releases/tag/${version}";
    homepage = "https://skrl.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
