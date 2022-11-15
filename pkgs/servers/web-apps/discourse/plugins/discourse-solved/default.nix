{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "76daa65b11a6c3b0c7ed7bc3fb60cdec0d8b09a4";
    sha256 = "sha256-q7RfaRFcvDUyz3mSO5bDZFGX7aAqzH978Ck812a627s=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-solved";
    maintainers = with maintainers; [ talyz ];
    license = licenses.mit;
    description = "Allow accepted answers on topics";
  };
}
