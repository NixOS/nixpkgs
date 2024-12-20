{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  einops,
  einx,
  hatchling,
  torch,
}:
buildPythonPackage rec {
  pname = "vector-quantize-pytorch";
  version = "1.20.11";
  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "vector-quantize-pytorch";
    tag = version;
    hash = "sha256-2Vi7q5N/xWsfu5KXk9rqbe0F40ufVjQyXkdPw/zPE4k=";
  };

  pyproject = true;

  propagatedBuildInputs = [
    einops
    einx
    hatchling
    torch
  ];

  pythonImportsCheck = [ "vector_quantize_pytorch" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Vector (and Scalar) Quantization, in Pytorch";
    homepage = "https://github.com/lucidrains/vector-quantize-pytorch";
    license = with lib.licenses; [ mit ];
  };
}
