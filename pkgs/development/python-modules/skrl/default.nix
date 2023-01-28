{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, gym
, torch
, tensorboard
, tqdm
, packaging
}:

buildPythonPackage rec {
  pname = "skrl";
  version = "0.8.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Toni-SM";
    repo = pname;
    rev = version;
    hash = "sha256-NfKgQyD7PkPOTnkIua3fOfH7tHNGQEOVZ2HtvIg5HzA=";
  };

  propagatedBuildInputs = [
    gym
    torch
    tensorboard
    tqdm
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
